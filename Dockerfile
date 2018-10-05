FROM microsoft/windowsservercore:10.0.14393.2485

LABEL maintainer="Uilian Ries <uilianries@gmail.com>"

SHELL ["powershell.exe", "-ExecutionPolicy", "Bypass", "-Command"]

ENV chocolateyUseWindowsCompression=false \
    PYTHONIOENCODING=UTF-8

RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RUN choco install --yes cmake --params '"/InstallDir:C:\tools\cmake"' --installargs 'ADD_CMAKE_TO_PATH=""System""'
RUN choco install --yes python3 --params '"/InstallDir:C:\tools\python3"'

RUN choco install --yes visualstudio2017buildtools --version=15.8.2.0 --execution-timeout=7200 --pacakge-parameters "--includeRecommend --includeOptional"

RUN python -m pip install --upgrade pip
RUN pip install win-unicode-console --upgrade --force-reinstall --no-cache
RUN pip install conan conan_package_tools --upgrade --force-reinstall --no-cache
# FIXME (uilian): idna raises error when installed by Conan/CPT
RUN pip install idna --upgrade --force-reinstall --no-cache

WORKDIR "C:/Users/ContainerAdministrator"
ENTRYPOINT ["cmd.exe", "C:\\Program Files (x86)\\Microsoft Visual C++ Build Tools\\vcbuildtools_msbuild.bat"]
