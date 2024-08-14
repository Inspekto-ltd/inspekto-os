import subprocess
import os
import json
import shutil
import os
from typing import TypedDict, List
from scrape_licenses import find_all_license_files

class PythonLicenseDict(TypedDict):
    License: str
    LicenseFile: str
    LicenseText: str
    Name: str
    version: str
    URL: str

def fetch_python_licenses():
    print('Warning - you have to be on a python environment with all packages installed')
    python_licenses_path = os.path.join(os.getcwd(), 'python_licenses')
    python_licenses_json = os.path.join(os.getcwd(), 'python_licenses.json')
    subprocess.call(f"pip install pip-licenses", shell=True)
    subprocess.call(f"pip-licenses --format=json --with-urls --with-license-file --output-file={python_licenses_json}", shell=True)

    python_licenses: List[PythonLicenseDict] = json.loads(open(python_licenses_json).read())

    if os.path.exists(python_licenses_path):
        shutil.rmtree(python_licenses_path)
    os.mkdir(python_licenses_path)

    for python_license_dict in python_licenses:
        updated_license_name = python_license_dict['Name'].replace('@', '').replace('/', '-')
        print(f'Working on {updated_license_name}')
        license_path = os.path.join(python_licenses_path, updated_license_name)
        if python_license_dict.get('licenseFile', 'UNKNOWN') != 'UNKNOWN':
            print(f'Copied licenseFile for {updated_license_name} from {python_license_dict["licenseFile"]}')
            shutil.copy2(python_license_dict['licenseFile'], license_path)
        else:
            if python_license_dict['URL'] != 'UNKNOWN':
                for license_text in find_all_license_files(
                        url=python_license_dict['URL'], package_name=python_license_dict['Name']):
                    print(f'Scraped {updated_license_name} at {python_license_dict["URL"]}')
                    with open(license_path, "w") as file:
                        file.write(license_text)
                    break
            else:
                print(f'Missing licenseFile and URL for {python_license_dict["Name"]}')

        if not os.path.isfile(license_path):
            print(f'Failed to add a licenseFile for {updated_license_name} at {license_path}')
        else:
            print(f'Successfully added a licenseFile for {updated_license_name} at {license_path}')


    # cleanup
    os.remove(python_licenses_json)

if __name__ == '__main__':
    fetch_python_licenses()

