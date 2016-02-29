Gem::Specification.new do |s|
    s.name        = 'fk_str'
    s.version     = '0.0.3'
    s.date        = '2013-01-19'
    s.summary     = 'FkStr'
    s.description = 'String manipulation.'

    s.required_ruby_version     = '>= 1.9.3'

    s.license = 'MIT'

    s.authors     = ['Guilherme Baptista']
    s.email       = 'guilhermebaptistasilva@gmail.com'
    s.homepage    = 'http://www.gbaptista.com'

    s.files       = [
        'LICENSE',
        'Rakefile'
    ] + Dir[
        'lib/*',
        'lib/fk_str/*'
    ]
    s.homepage    = 'https://github.com/gbaptista/fk_str'

end
