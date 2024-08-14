from typing import Iterable, Optional

import requests
from bs4 import BeautifulSoup
import re
from urllib.parse import urlparse, urlunparse, urljoin
import os

GITHUB_PATTERN = re.compile('github.com/.*/.*')
VARIANTS = ['LICENSE', 'COPYING', 'COPYRIGHT', 'LICENCE']

class URL:
    @staticmethod
    def normalize_url(url):
        return url if '//' in url else "http://" + url

    def __init__(self, url):
        self.url = urlparse(URL.normalize_url(url))

    def __repr__(self):
        return urlunparse(self.url)

    def split_path(self):
        path_in_site = os.path.normpath(self.url.path)
        path_list = path_in_site.split("/")
        return path_list

    def change_path(self, path_list):
        if path_list[0] != '':
            path_list = [''] + path_list
        parsed_url = list(self.url)
        parsed_url[2] = "/".join(path_list)
        return URL(urlunparse(parsed_url))

    def __getitem__(self, key):
        if isinstance(key, slice):
            return self.change_path(self.split_path()[key])

        elif isinstance(key, int):
            return self.split_path()[key]

    def __eq__(self, other):
        return str(self) == str(other)

    def __hash__(self):
        return hash(str(self))


def get_all_links_in_page(url: str):
    try:
        response = requests.get(url, timeout=5)
    except requests.exceptions.RequestException as e:
        print(e)
        response = None

    if response:
        soup = BeautifulSoup(response.text, 'html.parser')
        links = [link.get('href') for link in soup.find_all('a') if link.get('href')]

    else:
        links = []
    # print(links)
    return links


def extract_github_links(links: Iterable[str]):
    github_links = [URL(valid_match.group(0))
                    for valid_match in
                    (re.search(GITHUB_PATTERN, link) for link in links)
                    if valid_match is not None]
    return github_links


def filter_github_repos(github_links: Iterable[URL], package_name: str):
    github_repos = set(url[:3] for url in github_links if len(url.split_path()) >= 3)
    repos_with_package_name = {url for url in github_repos
                               if url[-1].lower() == package_name.lower()}
    return repos_with_package_name if repos_with_package_name else github_repos


def scrape_repos_licenses(repos_urls: Iterable[URL], package_name: Optional[str] = None):
    counter = 0
    output_file_path = None

    paths_to_license = set()
    for repo_url in repos_urls:
        response = requests.get(repo_url)
        soup = BeautifulSoup(response.text, 'html.parser')
        paths_to_license.update(set(
            link.get('href') for link in
            soup.find_all('a',
                          {
                              'href': re.compile('(.+?(license|copying|copyright|licence)(?:\\..+?)?)', re.IGNORECASE)
                          })
            if link.get('href')))
        # print(paths_to_license)
    for license_path in paths_to_license:
        full_url_to_license = URL(urljoin('https://raw.githubusercontent.com',
                                          license_path))
        url_path = full_url_to_license.split_path()

        if 'blob' in url_path:
            url_path.remove('blob')
            full_url_to_license = full_url_to_license.change_path(url_path)

        license_response = requests.get(full_url_to_license)
        if license_response and '<html' not in license_response.text:
            print(full_url_to_license)
            yield license_response.text
            counter += 1


def find_all_license_files(url, package_name):
    if 'github.com' not in url:
        all_links = get_all_links_in_page(url)
        github_links = extract_github_links(all_links)
    else:
        github_links = [URL(url)]

    github_repos = filter_github_repos(github_links, package_name)
    # print(github_repos)

    for license_text in scrape_repos_licenses(github_repos, package_name):
        yield license_text


if __name__ == '__main__':
    url = 'https://github.com/zopefoundation/zope.event'
    package_name = 'zope.event'
    for license_text in find_all_license_files(url=url, package_name=package_name):
        print(package_name)
        print(license_text)