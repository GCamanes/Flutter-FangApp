import os

from constants import ConstantsHandler
from function_helper import FunctionHelper

Constants = ConstantsHandler()
FunctionHelper = FunctionHelper()


class ChapterInfoModel:
    def __init__(self, link, htmlContent):
        self.link = link
        self.mangaKey = link.split('/')[1]
        self.number = FunctionHelper.getChapterNumber('9999')
        self.pagesLink = []
        self.nextLink = None
        self.prevLink = None

        nextLineChapterNumber = False

        for line in htmlContent:
            if nextLineChapterNumber:
                nextLineChapterNumber = False
                try:
                    self.number = FunctionHelper.getChapterNumber(
                        line.split('Chapter ')[-1].split('</span>')[0].split(':')[0].strip())
                except:
                    pass

            if '<h1>' in line:
                nextLineChapterNumber = True

            if "❮</a>" in line and 'href="' in line and Constants.DISABLED not in line:
                try:
                    self.prevLink = line.split('href="')[-1].split('"')[0]
                except:
                    pass

            if "❯</a>" in line and 'href="' in line and Constants.DISABLED not in line:
                try:
                    self.nextLink = line.split('href="')[-1].split('"')[0]
                except:
                    pass

            if 'onerror' in line and self.mangaKey in line:
                newPageLink = line.split("this.src='")[-1].split("'")[0]
                self.pagesLink.append('{}{}'.format(Constants.HTTPS, newPageLink))

    def toString(self):
        return 'Chapter n°: {}\nLink: {}\nPages: {}\nPrev chapter: {}\nNext chapter: {}'.format(
            self.number,
            self.link,
            len(self.pagesLink),
            self.prevLink,
            self.nextLink,
        )

    # Function to build chapter dl path
    def buildChapterPath(self):
        return '{}/{}/{}_chap_{}'.format(Constants.MANGA_DL_PATH, self.mangaKey, self.mangaKey, self.number)

    # Function to create chapter dl directory
    def createChapterDirectory(self):
        chapterPath = self.buildChapterPath()
        if not os.path.exists(chapterPath):
            os.makedirs(chapterPath)
            return True
        return False

    # Function to download pages
    def downloadChapterPages(self):
        needToDownload = self.createChapterDirectory()
        if needToDownload:
            for (pageLink, index) in zip(self.pagesLink, range(1, len(self.pagesLink)+1)):
                pageNumber = FunctionHelper.getPageName(str(index))
                extension = pageLink.split('.')[-1]
                pageFileName = '{}_chap_{}_page_{}.{}'.format(
                    self.mangaKey,
                    self.number,
                    pageNumber,
                    extension
                )
                pageFilePath = '{}/{}'.format(self.buildChapterPath(), pageFileName)
                commandLine = "curl -o '{}' '{}'".format(pageFilePath, pageLink)
                # Download img file
                os.system(commandLine)
                # Rename file with real extension
                FunctionHelper.renameFileExtension(pageFilePath) \
                    .split(Constants.MANGA_DL_PATH+'/')[-1]

        return needToDownload
