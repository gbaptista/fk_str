Install
--------

```shell
gem install fk_str
```

Usage
--------

### treat_encoding
```ruby
treat_encoding(str:"string")

FkStr.treat_encoding("\xE7") # returns 'ç'

FkStr.treat_encoding("ca\xE7a") # returns 'caça'
```

### is_eq
```ruby
is_eq(str_a:"string", str_b:"string", equals_percentage:integer)

FkStr.is_eq('Armagedon + Atos de Vingança', 'Armagedom') # returns true

FkStr.is_eq('Gato Cat', 'Cachorro Dog') # returns false
```

### to_slug
```ruby
to_slug(str:"string")

FkStr.to_slug('teste:dog') # returns 'teste-dog'

FkStr.to_slug('São Paulo/SP') # returns 'sao-paulo-sp'
```

### to_term
```ruby
to_term(str:"string", returns_array?:boolean)

FkStr.to_term('casa & dog and cachorro e lorem') # returns 'kasadujkakurururi'

FkStr.to_term('teste:de\dog') # returns 'tistiduj'
```

### remove_accents
```ruby
remove_accents(str:"string")

FkStr.remove_accents('São José do Rio Preto - SP') # returns 'Sao Jose do Rio Preto - SP'

FkStr.remove_accents('Açougue') # returns 'Acougue'
```

### upcasewords
```ruby
upcasewords(str:"string")

FkStr.upcasewords('CHARLIE BROWN JR.') # returns 'Charlie Brown Jr.'

FkStr.upcasewords('QUEENSRŸCHE') # returns 'Queensrÿche'
```

### remove_if_ends_with
```ruby
remove_if_ends_with(
  str:"string", texts:array, not_change_if_returns:string,
  if_not_change_returns_with_last_x_removed:integer
)

FkStr.remove_if_ends_with('Masp São Paulo/SP', ['São Paulo', 'SP', '/']) # returns 'Masp'

assert_equal(
  'Natal La Barra - Caxias do Sul',
	FkStr.remove_if_ends_with(
		'Natal La Barra - Caxias do Sul / RS',
		['La Barra', 'Caxias do Sul', 'RS', '/', '-'],
		['Natal'],
		3
	)
) # returns 'Natal La Barra - Caxias do Sul'
```

### extract_dates
```ruby
extract_dates(str:"string", reference_date:time, reverse_month_day:boolean)

FkStr.extract_dates(
  'December 06, 2012',
  Time.new(2012, 9, 12)
) # returns [Time.new(2012, 12, 6)]

FkStr.extract_dates(
  '8/dez lorem 9/jan/2012', Time.new(2011, 10, 8)
) # returns [Time.new(2011, 12, 8), Time.new(2012, 1, 9)]
```

### extract_time
```ruby
extract_time(str:"string", date:time, reference_time:time)

FkStr.extract_time(
	'Thu, 14 Jul 2011 22:18:49 +0000',
	FkStr.extract_dates('Thu, 14 Jul 2011 22:18:49 +0000',Time.new(2012, 5, 28)).first,
	Time.new(2012, 5, 28)
) # returns Time.new(2011, 07, 14, 22, 18, 0)

FkStr.extract_time(
	'14 Jul 2011 07:35',
	FkStr.extract_dates('14 Jul 2011 07:35',Time.new(2012, 5, 28)).first,
	Time.new(2012, 5, 28)
) # returns Time.new(2011, 07, 14, 7, 35, 0)
```