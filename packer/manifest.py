#!/usr/bin/env python
import argparse
import hashlib
import json


class Manifest(object):
  def __init__(self, name=None, description=None, versions=None):
    self.name = name
    self.description = description
    self.versions = versions

  def load(self, filename):
    with open(filename, 'rb') as f:
      data = json.load(f)
    self.name = data['name']
    self.description = data['description']
    self.versions = []
    for i in data['versions']:
      providers = [ManifestProvider(**j) for j in i['providers']]
      self.versions.append(ManifestVersion(i['version'], providers)) 

  def save(self, filename):
    data = {
      'name': self.name,
      'description': self.description,
      'versions': [x.to_dict() for x in self.versions],
    }

    with open(filename, 'wb') as f:
      json.dump(data, f, indent=2)

  def add_version(self, version, provider, url, checksum, checksum_type='sha256'):
    if self.versions is None:
      self.versions = []

    prov = ManifestProvider(
      name=provider,
      url=url,
      checksum=checksum,
      checksum_type=checksum_type,
    )

    for v in self.versions:
      if v.version == version:
        for p in v.providers:
          if p.name == provider:
            p.url = url
            p.checksum = checksum
            return
        v.providers.append(prov)
        return
    ver = ManifestVersion(version=version, providers=[prov])
    self.versions.append(ver)
    return


class ManifestVersion(object):
  def __init__(self, version, providers):
    self.version = version
    self.providers = providers

  def to_dict(self):
    return {
      'version': self.version,
      'providers': [x.to_dict() for x in self.providers],
    }


class ManifestProvider(object):
  def __init__(self, name, url, checksum_type, checksum):
    self.name = name
    self.url = url
    self.checksum_type = checksum_type
    self.checksum = checksum

  def to_dict(self):
    return {
      'name': self.name,
      'url': self.url,
      'checksum_type': self.checksum_type,
      'checksum': self.checksum,
    }


def get_box_file_checksum(filename):
  with open(filename, 'rb') as f:
    m = hashlib.sha256()
    chunk = f.read(4096)
    while len(chunk) > 0:
      m.update(chunk)
      chunk = f.read(4096)
    return m.hexdigest()


if __name__ == "__main__":
  parser = argparse.ArgumentParser(description='A tool for creating and updating Vagrant box manifests')
  parser.add_argument('--update', action='store_true', help='Update the manifest instead of creating a new one')
  parser.add_argument('--description', action='store', required=True, help='Box description')
  parser.add_argument('filename', type=str, help='Name of manifest file')
  parser.add_argument('box_filename', type=str, help='Box filename')
  parser.add_argument('name', type=str, help='Box name')
  parser.add_argument('version', type=str, help='Box version')
  parser.add_argument('provider', type=str, help='Box provider type')
  parser.add_argument('url', type=str, help='URL where box will be available')
  args = parser.parse_args()

  manifest = Manifest(
    name=args.name,
    description=args.description,
  )

  if args.update:
    try:
      manifest.load(args.filename)
    except IOError:
      pass

  checksum = get_box_file_checksum(args.box_filename)
  manifest.add_version(
    version=args.version,
    provider=args.provider,
    url=args.url,
    checksum=checksum,
    checksum_type='sha256',
  )

  manifest.save(args.filename)
