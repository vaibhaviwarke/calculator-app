import setuptools
 
# with open("README.md", "r") as fh:
#     long_description = fh.read()


setuptools.setup(
    name="calculator-app",
    version="0.0.1",
    use_scm_version={
        'version_scheme': 'release-branch-semver',
    },
    author="Ron LEsteve",
    author_email="ronlesteve@ronlesteve.com",
    description="Package to create artifacts",
    long_description='long_description',
    long_description_content_type="text/markdown",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.7',
)