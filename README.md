# OpenStudio AEDG Measures 

AEDG measures used by OpenStudio.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'openstudio-aedg-measures'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install 'openstudio-aedg-measures'

# Compatibility Matrix

|OpenStudio AEDG Gem|OpenStudio|Ruby|
|:--------------:|:----------:|:--------:|
| 0.4.0 | 3.2      | 2.7    |
| 0.3.0 | 3.1      | 2.5    |
| 0.2.0  | 3.0      | 2.5    |
| 0.1.1 | 2.9     | 2.2.4    |

# Contributing 

Please review the [OpenStudio Contribution Policy](https://openstudio.net/openstudio-contribution-policy) if you would like to contribute code to this gem.

## TODO

- [ ] Remove measures from OpenStudio-Measures to standardize on this location

# Releasing

* Update CHANGELOG.md
* Run `rake rubocop:auto_correct`
* Update version in `/lib/openstudio/aedg_measures/version.rb`
* Create PR to master, after tests and reviews complete, then merge
* Locally - from the master branch, run `rake release`
* On GitHub, go to the releases page and update the latest release tag. Name it “Version x.y.z” and copy the CHANGELOG entry into the description box.


