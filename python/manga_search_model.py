class MangaSearchModel:
    def __init__(self, htmlToParse):
        try:
            self.title = htmlToParse.split('title="')[1].split('" href')[0]
            self.link = htmlToParse.split('href="')[1].split('"><img')[0]
        except:
            self.title = ''
            self.link = ''

    def toString(self):
        return '{} ({})'.format(self.title, self.link)
