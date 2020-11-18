

r'^abc[ab]+\s\t\d'
# not a date
r'^\d{1,2}\/\d{1,2}\/\d{4}$'

r'\s*[a-zA-Z,\s]+\s*'

date = "30/04/1998"
re.findall(r'[0-3]\d{1}\/[01]\d{1}\/19\d{2}$|[0-3]\d{1}\/[01]\d{1}\/20\d{2}$', date)

re.findall(r'[0-3]\d{1}\/[01]\d{1}\/19\d{2}$', date)