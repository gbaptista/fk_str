# encoding: utf-8
module FkStr
	@@months_strs = {
		'jan' => 1, 'fev' => 2, 'mar' => 3, 'abr' => 4, 'mai' => 5, 'jun' => 6,
		'jul' => 7, 'ago' => 8, 'set' => 9, 'out' => 10, 'nov' => 11, 'dez' => 12,
		'/1' => 1, '/2' => 2, '/3' => 3, '/4' => 4,
		'/5' => 5, '/6' => 6, '/7' => 7, '/8' => 8, '/9' => 9,
		'/01' => 1, '/02' => 2, '/03' => 3, '/04' => 4, '/05' => 5, '/06' => 6,
		'/07' => 7, '/08' => 8, '/09' => 9, '/10' => 10, '/11' => 11, '/12' => 12,
		'feb' => 2, 'apr' => 4, 'may' => 5, 'aug' => 8, 'sep' => 9, 'oct' => 10, 'dec' => 12
	}

	@@letters_by_letter = {
		'a' => { 'a' => 'A', 'á' => 'Á', 'ã' => 'Ã', 'â' => 'Â', 'à' => 'À', 'ä' => 'Ä', 'ă' => 'Ă', 'ā' => 'Ā', 'å' => 'Å', 'æ' => 'Æ' },
		'b' => { 'b' => 'B' },
		'c' => { 'c' => 'C', 'ç' => 'Ç', 'č' => 'Č' },
		'd' => { 'd' => 'D' },
		'e' => { 'e' => 'E', 'é' => 'É', 'ẽ' => 'Ẽ', 'ê' => 'Ê', 'è' => 'È', 'ë' => 'Ë', 'ĕ' => 'Ĕ', 'ē' => 'Ē' },
		'f' => { 'f' => 'F' },
		'g' => { 'g' => 'G', 'ğ' => 'Ğ' },
		'h' => { 'h' => 'H' },
		'i' => { 'i' => 'I', 'í' => 'Í', 'ĩ' => 'Ĩ', 'î' => 'Î', 'ì' => 'Ì', 'ï' => 'Ï', 'ĭ' => 'Ĭ', 'ī' => 'Ī' },
		'j' => { 'j' => 'J' },
		'k' => { 'k' => 'K' },
		'l' => { 'l' => 'L' },
		'm' => { 'm' => 'M' },
		'n' => { 'n' => 'N', 'ñ' => 'Ñ' },
		'o' => { 'o' => 'O', 'ó' => 'Ó', 'õ' => 'Õ', 'ô' => 'Ô', 'ò' => 'Ò', 'ö' => 'Ö', 'ŏ' => 'Ŏ', 'ō' => 'Ō', 'ő' => 'Ő', 'ð' => 'Ð' },
		'p' => { 'p' => 'P' },
		'q' => { 'q' => 'Q' },
		'r' => { 'r' => 'R' },
		's' => { 's' => 'S', 'š' => 'Š' },
		't' => { 't' => 'T' },
		'u' => { 'u' => 'U', 'ú' => 'Ú', 'ũ' => 'Ũ', 'û' => 'Û', 'ù' => 'Ù', 'ü' => 'Ü', 'ŭ' => 'Ŭ', 'ū' => 'Ū', 'ǖ' => 'Ǖ' },
		'v' => { 'v' => 'V' },
		'w' => { 'w' => 'W' },
		'x' => { 'x' => 'X' },
		'y' => { 'y' => 'Y', 'ȳ' => 'Ȳ', 'ÿ' => 'Ÿ', 'ý' => 'Ý', 'ỳ' => 'Ỳ' },
		'z' => { 'z' => 'Z', 'ž' => 'Ž' }
	}

	@@articles_and_others = [
		# Português
		'a', 'ao', 'aos', 'as',
		'co', 'coa', 'coas', 'com', 'cos',
		'da', 'das', 'de', 'do', 'dos', 'dum', 'duma', 'dumas', 'duns',
		'e', 'em',
		'na', 'nas', 'no', 'nos', 'num', 'numa', 'numas', 'nuns',
		'o', 'os', 'ou',
		'pela', 'pelas', 'pelo', 'pelos', 'per', 'por',
		'um', 'uma', 'umas', 'uns',
		# English
		'an', 'and', 'at', 'by', 'in', 'of', 'or', 'on', 's', 'the'
	]
	def FkStr.articles_and_others
		return @@articles_and_others
	end

	@@countries_acronyms = [
		# Brasil
		'br',
		'ac', 'al', 'ap', 'am', 'ba', 'ce', 'df', 'es', 'go', 'ma', 'mt','ms', 'mg', 'pa', 'pb',
		'pr', 'pe', 'pi', 'rj', 'rn', 'rs', 'ro', 'rr', 'sc', 'sp', 'se', 'to',
		# USA
		'us',
		'ak', 'al', 'ar', 'az', 'ca', 'co', 'ct', 'dc', 'de', 'fl', 'ga', 'hi', 'ia', 'id', 'il',
		'in', 'ks', 'ky', 'la', 'ma', 'md', 'me', 'mi', 'mn', 'mo', 'ms', 'mt', 'nc', 'nd', 'ne',
		'nh', 'nj', 'nm', 'nv', 'ny', 'oh', 'ok', 'or', 'pa', 'ri', 'sc', 'sd', 'tn', 'tx', 'ut',
		'va', 'vt', 'wa', 'wi', 'wv', 'wy'
	]
	def FkStr.countries_acronyms
		return @@countries_acronyms
	end

	@@simple_downcase_letters = [
		'a', 'b', 'c', 'd', 'e',
		'f', 'g', 'h', 'i', 'j',
		'k', 'l', 'm', 'n', 'o',
		'p', 'q', 'r', 's', 't',
		'u', 'v', 'w', 'x', 'y',
		'z'
	]

	@@simple_downcase_consonants = [
		'b', 'c', 'd',
		'f', 'g', 'h', 'j',
		'k', 'l', 'm', 'n',
		'p', 'q', 'r', 's', 't',
		'v', 'w', 'x', 'y',
		'z'
	]

	@@separators = ['/', '-', '_', ',', '.', "'", '"', '(', ')', '[', ']', '{', '}', '|', '\\', ';']
	def FkStr.separators
		return @@separators
	end

	@@separators_regex = ['\/', '\-', "\'", '\"', '\(', '\)', '\[', '\]', '\{', '\}']

	@@legal_chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz _-!@#$%&*+=?^~´`,.:;\'"()[]{}|/\\<>ÁÃÂÀÄĂĀÅÆáãâàäăāåæÉẼÊÈËĔĒéẽêèëĕēÍĨÎÌÏĬĪíĩîìïĭīÓÕÔÒÖŎŌŐÐóõôòöŏōőðšŠÚŨÛÙÜŬŪǕúũûùüŭūǖÇçČčĞğÑñȲȳŸÿÝýỲỳŽž¹²³ºª	– ’©®℗¿¡±“”•«»‘°'.split('')

	@@invalid_sequences = ['Ã©']
end
