# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.3] - 2020-02-18
### Added
- added retention policy support.

## [1.0.2] - 2020-02-17
### Added
- added $users parameter to ::influxdb [@unki](https://github.com/unki).
- added $databases parameter to ::influxdb [@unki](https://github.com/unki).
- README: fix influxdb::user privilege-parameter [@unki](https://github.com/unki).

### Changed
- adapt reading privileges from InfluxDB grants in case of ALL-PRIVILEGES [@unki](https://github.com/unki).
