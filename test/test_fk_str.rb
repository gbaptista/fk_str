# encoding: utf-8

require 'test/unit'
require 'fk_str'

class FkStrTest < Test::Unit::TestCase

	def test_treat_encoding

		assert_equal(
			'çUTF-8',
			FkStr.treat_encoding("\xE7")+FkStr.treat_encoding("\xE7").encoding.to_s.upcase
		)

		assert_equal(
			'©UTF-8',
			FkStr.treat_encoding("\xC2\xA9")+FkStr.treat_encoding("\xC2\xA9").encoding.to_s.upcase
		)

		assert_equal(
			'caçaUTF-8',
			FkStr.treat_encoding("ca\xE7a")+FkStr.treat_encoding("ca\xE7a").encoding.to_s.upcase
		)

		assert_equal(
			'casaUTF-8',
			FkStr.treat_encoding('casa')+FkStr.treat_encoding('casa').encoding.to_s.upcase
		)

	end

	def test_is_eq

		assert_equal(
			true,
			FkStr.is_eq('Hangar 110', 'Hangar 110', 40)
		)

		assert_equal(
			true,
			FkStr.is_eq('Armagedon + Atos de Vingança', 'Armagedom')
		)

		assert_equal(
			false,
			FkStr.is_eq('Gato Cat', 'Cachorro Dog')
		)

		assert_equal(
			true,
			FkStr.is_eq('Creedence Clearwater Revisited', 'Creedence Clearwater')
		)

	end

	def test_to_slug

		assert_equal(
			'teste-dog',
			FkStr.to_slug('teste:dog')
		)

		assert_equal(
			'centro-rio-de-janeiro-rj',
			FkStr.to_slug('Centro - Rio de Janeiro [RJ]')
		)

		assert_equal(
			'sao-paulo-sp',
			FkStr.to_slug('São Paulo/SP')
		)

		assert_equal(
			'sao-paulo-sp',
			FkStr.to_slug('São Paulo_SP')
		)

	end

	def test_to_term

		assert_equal(
			'kasadujkakurururi',
			FkStr.to_term('casa & dog and cachorro e lorem')
		)

		assert_equal(
			'tistiduj',
			FkStr.to_term('teste:de\dog')
		)

		assert_equal(
			'saupauru',
			FkStr.to_term('São Paulo-SP')
		)

		assert_equal(
			'tistiduj',
			FkStr.to_term('teste:de:dog')
		)

	end

	def test_remove_accents

		assert_equal(
			'Sao Jose do Rio Preto - SP',
			FkStr.remove_accents('São José do Rio Preto - SP')
		)

		assert_equal(
			'Sao Paulo',
			FkStr.remove_accents('São Paulo')
		)

		assert_equal(
			'Acougue',
			FkStr.remove_accents('Açougue')
		)

		assert_equal(
			'Lorem Ipsum',
			FkStr.remove_accents('Lôrém Ipsum')
		)

	end

	def test_downcase
		
		assert_equal(
			'açúcar',
			FkStr.downcase('AÇÚCAR')
		)

	end

	def test_upcasewords

		assert_equal(
			'Charlie Brown Jr.',
			FkStr.upcasewords('CHARLIE BROWN JR.')
		)

		assert_equal(
			'Coldplay',
			FkStr.upcasewords('COLDPLAY')
		)

		assert_equal(
			'Queensrÿche',
			FkStr.upcasewords('QUEENSRŸCHE')
		)

		assert_equal(
			'Mindflow',
			FkStr.upcasewords('MINDFLOW')
		)

	end

	def test_remove_if_ends_with

		assert_equal(
			'Natal La Barra',
			FkStr.remove_if_ends_with(
				'Natal La Barra - Caxias do Sul / RS',
				['La Barra', 'Caxias do Sul', 'RS', '/', '-'],
				['Natal'],
				1
			)
		)

		assert_equal(
			'Natal La Barra -',
			FkStr.remove_if_ends_with(
				'Natal La Barra - Caxias do Sul / RS',
				['La Barra', 'Caxias do Sul', 'RS', '/', '-'],
				['Natal'],
				2
			)
		)

		assert_equal(
			'Natal La Barra - Caxias do Sul',
			FkStr.remove_if_ends_with(
				'Natal La Barra - Caxias do Sul / RS',
				['La Barra', 'Caxias do Sul', 'RS', '/', '-'],
				['Natal'],
				3
			)
		)

		assert_equal(
			'Masp',
			FkStr.remove_if_ends_with('Masp São Paulo/SP', ['São Paulo', 'SP', '/'])
		)

	end

	def test_extract_dates

		assert_equal(
			[Time.new(2012, 12, 6)].uniq.sort,
			FkStr.extract_dates('December 06, 2012', Time.new(2012, 9, 12))
		)

		assert_equal(
			[Time.new(2012, 9, 14)].uniq.sort,
			FkStr.extract_dates('FRI 09.14.2012', Time.new(2012, 9, 12), true)
		)

		assert_equal(
			[Time.new(2011, 12, 8), Time.new(2012, 1, 9)].uniq.sort,
			FkStr.extract_dates('8/dez lorem 9/jan/2012', Time.new(2011, 10, 8))
		)

		assert_equal(
			[Time.new(2012, 1, 2)].uniq.sort,
			FkStr.extract_dates('2 de janeiro', Time.new(2011, 10, 8))
		)

	end

	def test_extract_time

		assert_equal(
			Time.new(2011, 07, 14, 22, 18, 0),
			FkStr.extract_time(
				'Thu, 14 Jul 2011 22:18:49 +0000',
				FkStr.extract_dates('Thu, 14 Jul 2011 22:18:49 +0000',Time.new(2012, 5, 28)).first,
				Time.new(2012, 5, 28)
			)
		)

		assert_equal(
			Time.new(2011, 07, 14, 16, 15, 0),
			FkStr.extract_time(
				'14 Jul 2011 16:15',
				FkStr.extract_dates('14 Jul 2011 16:15',Time.new(2012, 5, 28)).first,
				Time.new(2012, 5, 28)
			)
		)

		assert_equal(
			Time.new(2011, 07, 14, 9, 0, 0),
			FkStr.extract_time(
				'14 Jul 2011 9:00',
				FkStr.extract_dates('14 Jul 2011 9:00',Time.new(2012, 5, 28)).first,
				Time.new(2012, 5, 28)
			)
		)

		assert_equal(
			Time.new(2011, 07, 14, 7, 35, 0),
			FkStr.extract_time(
				'14 Jul 2011 07:35',
				FkStr.extract_dates('14 Jul 2011 07:35',Time.new(2012, 5, 28)).first,
				Time.new(2012, 5, 28)
			)
		)

	end

end