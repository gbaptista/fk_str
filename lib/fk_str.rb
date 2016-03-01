require 'pry'

# encoding: utf-8
module FkStr
	def self.treat_encoding str, debug=false
		str_r = ''
		str.lines.each_with_index { |l, i| str_r += ' ' + self.treat_encoding_s(l, debug) if !debug or (i > -1 and i < 1) }
		return str_r.strip
	end

	def self.is_eq str_a, str_b, pct=1, already_term=false, return_pct=false
		unless already_term
			str_a = self.to_term str_a, true
			str_b = self.to_term str_b, true
		end

		return true if str_a == str_b

		if str_a.size > str_b.size
			larger_string  = str_a
			smaller_string = str_b
		else
			larger_string  = str_b
			smaller_string = str_a
		end

		equal_words = 0

		smaller_string.each do |word|
			equal_words += 1 if larger_string.include? word
		end

		equal_pct = (100 * equal_words) / larger_string.size

		if return_pct
			return [true, equal_pct] if (equal_pct >= pct)

			return [false, equal_pct]
		else
			return true if (equal_pct >= pct)

			return false
		end
	end

	def self.to_slug str
		return str if str.to_s == ''

		return self.remove_accents(str).gsub(/\s{1,}| {1,}/, ' ').gsub(/[\+\/_\-|:@#\\,\(\)]/, ' ').gsub('&', 'e').gsub(/[^a-zA-Z0-9 ]/, '').downcase.gsub(/\s{1,}| {1,}/, ' ').strip.gsub(' ', '-')
	end

	def self.to_term str, ar=false

		return str if str.to_s == ''

		str_ar = []

		self.to_slug(str).split('-').each do |s|
			s.split('').uniq.each { |r| s = s.gsub /#{r}{2,}/, r }
			@@simple_downcase_consonants.each { |c| s = s.gsub /#{c}(h|r|l|u)/, c }
			if !s.empty? and !@@countries_acronyms.include? s and !@@articles_and_others.include? s
				s = s.gsub /m/, 'n'
				s = s.gsub /l/, 'r'
				s = s.gsub /z/, 's'
				s = s.gsub /g/, 'j'
				s = s.gsub /e|y/, 'i'
				s = s.gsub /o|w/, 'u'
				s = s.gsub /c|q/, 'k'
				s.split('').uniq.each { |r| s = s.gsub /#{r}{2,}/, r }
				s = s.gsub /(r|s|n)$/, ''
				str_ar << s if !s.empty?
			end
		end

		return str_ar.uniq if ar

		return str_ar.uniq.join

	end

	def self.remove_accents str

		return '' if str.to_s == ''
		str = str.gsub(/[ÁÃÂÀÄĂĀÅÆ]/, 'A').gsub(/[áãâàäăāåæ]/, 'a')
		str = str.gsub(/[ÉẼÊÈËĔĒ]/, 'E').gsub(/[éẽêèëĕē]/, 'e')
		str = str.gsub(/[ÍĨÎÌÏĬĪ]/, 'I').gsub(/[íĩîìïĭī]/, 'i')
		str = str.gsub(/[ÓÕÔÒÖŎŌŐÐ]/, 'O').gsub(/[óõôòöŏōőð]/, 'o')
		str = str.gsub(/[ÚŨÛÙÜŬŪǕ]/, 'U').gsub(/[úũûùüŭūǖ]/, 'u')
		str = str.gsub(/[ÇČ]/, 'C').gsub(/[çč]/, 'c').gsub(/Ğ/, 'G').gsub(/ğ/, 'g').gsub(/Ñ/, 'N').gsub(/ñ/, 'n').gsub(/Š/, 'S').gsub(/š/, 's')
		str = str.gsub(/[ȲŸÝỲ]/, 'Y').gsub(/[ȳÿýỳ]/, 'y').gsub(/Ž/, 'Z').gsub(/ž/, 'z')

		return str

	end

	def self.upcase w

		return w if w.to_s == ''

		# Cria uma Array apenas com os caracteres necessários por questões de performance.
		letters = []
		clean_word = self.remove_accents(w).downcase.gsub(/[^a-z]/, '')
		clean_word.split('').uniq.each { |lt| @@letters_by_letter[lt].each { |l| letters << l } }

		letters.each do |l|

			# Transforma tudo em maiúsculo.
			w = w.gsub l[0], l[1]

		end

		return w

	end

	def self.downcase w

		return w if w.to_s == ''

		# Cria uma Array apenas com os caracteres necessários por questões de performance.
		letters = []
		clean_word = self.remove_accents(w).downcase.gsub(/[^a-z]/, '')
		clean_word.split('').uniq.each { |lt| @@letters_by_letter[lt].each { |l| letters << l } }

		letters.each do |l|

			# Transforma tudo em minúsculo.
			w = w.gsub l[1], l[0]

		end

		return w

	end

	# 35 seconds
	# 18 seconds
	# 16 seconds
	def self.upcasewords str

		return str if str.to_s == ''

		# Trata espaçamentos duplicados ou inválidos.
		str = str.gsub(/\s{1,}| {1,}/, ' ').strip

		rstr = []
		str.split(' ').each { |w| rstr << upcaseword(w) }
		str = rstr.join(' ')

		# Trata espaçamentos duplicados ou inválidos.
		str = str.gsub(/\s{1,}| {1,}/, ' ')

		# Maiúsculo na primeira letra
		fl = @@letters_by_letter[remove_accents(str[0]).downcase]
		fl.each { |l| str[0] = str[0].gsub(l[0], l[1]) } if fl

		return str

	end

	def self.remove_if_ends_with str, texts, not_change_if_returns_with=nil, if_not_change_returns_with_last_removed=0

		return str if str.split(' ').size == 1

		texts.each_with_index { |t, i| texts.delete_at i if t == '' }

		str_o = str

		str = str.strip

		str_t = self.remove_accents(str).downcase

		texts = texts.uniq

		texts.each_with_index { |v, i| texts[i] = self.remove_accents(v).downcase }

		not_change_if_returns_with.each_with_index { |v, i| not_change_if_returns_with[i] = self.remove_accents(v).downcase } if !not_change_if_returns_with.nil?

		removed = []

		continue = true
		while continue
			continue = false
			texts.each do |t|

				# Se o final da string for igual ao termo...
				if t == str_t[str_t.size-t.size..str_t.size].to_s

					# Se antes do termo final na string não for igual à ' de ' ou ' da '...
					if ![' de ', ' da '].include? str_t[str_t.size-t.size-4].to_s + str_t[str_t.size-t.size-3..str_t.size-t.size-2].to_s + str_t[str_t.size-t.size-1].to_s

						# Se o primeiro char do termo não for uma letra ou se o
						# char anterior ao termo não for uma letra...
						if (!@@simple_downcase_letters.include? t[0] or !@@simple_downcase_letters.include? str_t[str_t.size-t.size-1]) and str_t.size > 1

							str_l = str

							str = str[0..str.size-t.size-1].strip
							str_t = self.remove_accents(str).downcase

							if str_l[str.size..str_l.size] != ''

								removed << str_l[str.size..str_l.size]

								continue = true

							else

								str = ''

							end

						end

					end

				end

			end
		end

		# Se o retorno for igual à alguma condição que não deve ser retornada...
		if !not_change_if_returns_with.nil?
			if not_change_if_returns_with.include?(self.remove_accents(str).downcase)
				# Se for solicitado que retorne apenas com x termos que foram removidos...
				if if_not_change_returns_with_last_removed > 0
					removed = removed.reverse
					(1..if_not_change_returns_with_last_removed).each { |n| str += removed[n-1].to_s }
					return str.strip
				end
				return str_o
			end
		end

		if str == ''
			return str_o
		else
			return str
		end

	end

	def self.extract_dates str, reference_date=Time.now, reverse_month_day=false

		return [] if str.nil?

		return [Time.new(str.year, str.month, str.day)] if str.kind_of?(Time) or str.kind_of?(Date) or str.kind_of?(DateTime)

		o_str = str

		years = []
		(-30..20).each { |y| years << reference_date.year+y }

		begin

			str = str.gsub /[0-9]{1,}(º|ª)/, ' '

			str = self.remove_accents str

			str = str.downcase

			str = str.gsub /[a-z]{1,}+[0-9]{1,}/, ' '

			str = str.gsub /[0-9]{1,}+[a-z]{1,}+[0-9]{1,}/, ''
			str = str.gsub /[0-9]{1,}+[a-z]{1,}/, ' '
			str = str.gsub /[a-z]{1,}+[0-9]{1,}/, ' '

			str = str.gsub(/[^a-z|^0-9|^\/|^\-|^\.|^:]/i, ' ')

			str = str.gsub(/[0-9]{1,}:[0-9]{1,}|:[0-9]{1,}|[0-9]{1,}h[0-9]{1,}|[0-9]{1,}%|[0-9]{1,}h |[0-9]{1,}h$|palco [0-9]{1,}/i, '')

			str.scan(/[0-9]{1,}+.+[0-9]{1,}/).each { |d| str = str.gsub(d, d.gsub('.', '/')) }

			if reverse_month_day
				str.scan(/[0-9]{1,}\/[0-9]{1,}/).each do |d|
					str = str.gsub(d, d.split('/')[1] + '/' + d.split('/')[0])
				end
			end

			@@months_strs.each do |mc|
				str.scan(/#{mc.first}.*[0-9]{1,2}+[1-9]{2,4}/).each do |md|
					if md.scan(/[0-9]{1,2}/).size < 4 and md.scan(/[0-9]{4,}/).size < (md.scan(/[0-9]{2,2}/).size-1)

						continue = true

						@@months_strs.each do |smc|
							md.scan(/[0-9].*#{smc.first}/).each do |d|
								continue = false
							end
						end
						if continue
							m = md.scan(/[0-9]{1,2}/).first
							str = str.gsub(/#{mc.first}.+#{m}/, "#{m} #{mc.first}").gsub(',', '')
						end
					end
				end
			end

			str.scan(/[0-9]{4,4}-[0-9]{1,2}-[0-9]{1,2}/).each do |y|
				str = str.gsub(y, y.split('-')[2] + '/' + y.split('-')[1] + '/' + y.split('-')[0])
			end

			str.scan(/[0-9]{4,4}\/[0-9]{1,2}\/[0-9]{1,2}/).each do |y|
				str = str.gsub(y, y.split('/')[2] + '/' + y.split('/')[1] + '/' + y.split('/')[0])
			end

			str.scan(/[0-9]{1,2}-[0-9]{1,2}-[0-9]{2,4}/).each do |y|
				str = str.gsub(y, y.split('-')[0] + '/' + y.split('-')[1] + '/' + y.split('-')[2])
			end

			str.scan(/[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{1,}/).each do |y|
				if y.split('/')[2].size < 4
					sr = y.split('/').first + '/' + y.split('/')[1]
					sy = y.split('/')[2]
					if sy.size < 3
						sy = '0' + sy if sy.size == 1
						if years.include? (reference_date.year.to_s[0..1]+sy).to_i
							sr += '/' + reference_date.year.to_s[0..1]+sy
						elsif years.include? ((reference_date.year-100).to_s[0..1]+sy).to_i
							sr += '/' + (reference_date.year-100).to_s[0..1]+sy
						end
					end
					str = str.gsub(y, sr)
				end
			end

			str = str.gsub(/[0-9]{5,}/, '')

			dates = []
			continue = true
			while continue

				@@months_strs.each do |m|

					str.scan(/([0-9].*#{m.first})+([^0-9]|$)/).each do |d|
						days = d.first.split(/(#{m.first})+([^0-9]|$)/).first
						jump=false
						@@months_strs.each do |mc|
							if days.scan(/([0-9].*#{mc.first})+([^0-9]|$)/).size > 0
								jump = true
							end
						end
						if !jump

							year = nil
							str.scan(/#{days}#{m.first}.*[0-9]{4,4}/).each do |sc|
								sy = sc.gsub(/(#{days}#{m.first})+([^0-9]|$)/, '')

								# [lorem 9/jan/2012] = false
								# [2012 e 07/05/2012] = true
								# [2012] = true

								if sy.scan(/[0-9]{4,4}/).size > 1 or (sy.scan(/[0-9]{4,4}/).size == 1 and !sy.gsub(/[0-9]{4,4}/, '').match(/[0,9]/))
									sy.scan(/[0-9]{4,4}/).each { |y| year=y.to_i if years.include? y.to_i; break; }
								end
							end

							#puts '[' + str + '] => ' + year.inspect
							str = str.gsub(/(#{days}#{m.first})+([^0-9]|$)/, '')
							#puts '[' + str + "\n\n"

							days.gsub(/[0-9]{4,4}/, '').scan(/[0-9]{1,2}/).each do |day|
								day = day.to_i
								if day > 0 and day < 32
									if year
										dates<<Time.new(year, m[1], day)
									elsif m[1]<(reference_date.month-3)
										dates<<Time.new(reference_date.year+1, m[1], day)
									else
										dates<<Time.new(reference_date.year, m[1], day)
									end
								end
							end
						end
					end
				end
				continue = false
				@@months_strs.each do |mt|
						if str.scan(/([0-9].*#{mt.first})+([^0-9]|$)/).size > 0
						continue = true
					end
				end
			end

			return dates.uniq.sort
		rescue => exc
			return []
		end
	end

	def self.extract_time str, date=nil, reference_time=Time.now
		return nil if date.nil?

		return Time.new(date.year, date.month, date.day, reference_time.hour, reference_time.min) if str.nil? or !str.match /[0-9]{1,2}:[0-9]{1,2}/

		str = str.gsub /[a-z]{1,}+[0-9]{1,}:/i, ' '

		begin
			time = str.scan(/[0-9]{1,2}:[0-9]{1,2}/).first.split(':')
			return Time.new(date.year, date.month, date.day, time[0], time[1])
		rescue => exp
			return Time.new(date.year, date.month, date.day, reference_time.hour, reference_time.min)
		end
	end

	private

	def self.treat_encoding_s str, debug=false
		begin
			str_r = ''
			ws = str.split(' ').each_slice(20)
			ws.each_with_index do |w, i|
				if i == 0
					str_r += self.treat_encoding_i w.join(' '), 0, debug
				else
					str_r += ' ' + self.treat_encoding_i(w.join(' '), 0, debug)
				end
			end
		rescue => exp
			str_r = ''
			str.chars.each_slice(200).each { |w| str_r += self.treat_encoding_i w.join, 0, debug }
		end
		return str_r
	end

	def self.valid_encoding str, tolerance=0, debug=false
		str_v = str
		begin
			str_v.match 'á'
			str_v = str_v.gsub /\s{1,}|\n{1,}|\r{1,}/, ''
			@@legal_chars.each { |lc| str_v = str_v.gsub lc, '' }
			@@invalid_sequences.each { |is| raise 'invalid sequence: ' + is if str.match is }
			puts '[' + str_v + ']' if debug and str_v.size > 0
			return false if str_v.size > tolerance
			str_v.split('').each { |c| str = str.gsub c, '' } if str_v.size > 0
			return str
		rescue => exp
			#puts '[error] ' + exp.message if debug or !exp.message.match /incompatible encoding|invalid byte sequence|invalid sequence/i
			return false
		end
	end

	def self.treat_encoding_i str, tolerance=0, debug=false
		str_t = str

		str_v = self.valid_encoding str_t, tolerance, debug
		if !str_v
			puts '[try force_encoding UTF-8]' if debug
			begin
				str_t = str.force_encoding 'UTF-8'
			rescue  => exp
			end
		else
			return str_v
		end

		str_v = self.valid_encoding str_t, tolerance, debug
		if !str_v
			puts '[try WINDOWS-1252]' if debug
			begin
				str_t = str.encode 'UTF-8', 'WINDOWS-1252'
			rescue  => exp
			end
		else
			return str_v
		end

		str_v = self.valid_encoding str_t, tolerance, debug
		if !str_v
			puts '[try UTF-8]' if debug
			begin
				str_t = str.encode 'UTF-8', 'UTF-8'
			rescue  => exp
			end
		else
			return str_v
		end

		str_v = self.valid_encoding str_t, tolerance, debug
		if !str_v
			puts '[try ISO-8859-2]' if debug
			begin
				str_t = str.encode 'UTF-8', 'ISO-8859-2'
			rescue  => exp
			end
		else
			return str_v
		end

		str_v = self.valid_encoding str_t, tolerance, debug
		if !str_v
			puts '[try ISO-8859-3]' if debug
			begin
				str_t = str.encode 'UTF-8', 'ISO-8859-3'
			rescue  => exp
			end
		else
			return str_v
		end

		str_v = self.valid_encoding str_t, tolerance, debug
		if tolerance == 0 and !str_v
			str_t = self.treat_encoding_i str, 1, debug
		end

		return str_t
	end

	def self.upcaseword w
		return w if w.to_s == ''

		if w.scan(/#{@@separators_regex.join('|')}/).size == 0

			# Cria uma Array apenas com os caracteres necessários por questões de performance.
			letters = []
			clean_word = self.remove_accents(w).downcase.gsub(/[^a-z]/, '')
			clean_word.split('').uniq.each { |lt| @@letters_by_letter[lt].each { |l| letters << l } }

			trf = 'tm'
			trf = 'tfu'	if w.size > 5 or !@@articles_and_others.include? clean_word
			trf = 'tau'	if !w.match(/^mr$|^jr$|^mr.$|^jr.$|^sr$|^sr.$/i) and ((w.size < 6 and clean_word.match(/[^aeiouwy]{4,}|[aeiouwy]{4,}|^[^aeiouwy]{2,3}$/)) or w.scan('.').size > 2)

			letters.each do |l|
				# Transforma tudo em minúsculo.
				w = w.gsub l[1], l[0] if trf == 'tm' || trf == 'tfu'

				# Maiúsculo na primeira letra caso não seja um artigo ou algo do gênero.
				w = w.gsub /^#{l[0]}/, l[1] if trf == 'tfu'

				# Transforma em maiúsculo:
				# * Sequência de 4 ou mais consoantes.
				# * Sequência de 4 ou mais vogais.
				# * Sequência exata de 2 ou 3 vogais.

				w = w.gsub l[0], l[1] if trf == 'tau'
			end

		else

			# Quebra termos entre caracteres separadores como "'", "(", etc.
			@@separators.each do |l|
				sw = w.split(l)
				if sw.size > 1
					# Trata o termo isoladamente se não for uma letra única antes de "'"
					sw.each_with_index { |v, i| sw[i] = upcaseword v if !(["'"].include? l and v.size == 1 and i == 0) }
					if w[w.size-1] == l
						w = sw.join(l) + l
					else
						w = sw.join(l)
					end
				end
			end
		end

		return w
	end
end
