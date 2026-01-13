# NLF Web

A modern web application for Neon Law Foundation built with Hummingbird and
Elementary.

## Overview

This is a Swift-based web application that serves the Neon Law Foundation
website. It uses:

- **Hummingbird** - Modern Swift web framework
- **Elementary** - Type-safe HTML rendering in Swift
- **Tailwind CSS** - Utility-first CSS framework (via CDN)

## Claude Code Development Setup

This project is part of the [Trifecta](https://github.com/neon-law-foundation/Trifecta) development environment, designed for full-stack Swift development with Claude Code.

**Recommended Setup**: Use the [Trifecta configuration](https://github.com/neon-law-foundation/Trifecta) which provides:
- Unified Claude Code configuration across all projects
- Pre-configured shell aliases for quick navigation
- Consistent development patterns and tooling
- Automated repository cloning and setup

**Working in Isolation**: This repository can also be developed independently. We maintain separate repositories (rather than a monorepo) to ensure:
- **Clear code boundaries** - Each project has distinct responsibilities and scope
- **Legal delineation** - Clear separation between software consumed by different entities (Neon Law Foundation, Neon Law, Sagebrush Services)
- **Independent deployment** - Each service can be versioned and deployed separately
- **Focused development** - Smaller, more manageable codebases

## Features

- Server-side rendered HTML using Elementary
- Static file serving for assets (logo, images, etc.)
- Responsive design with Tailwind CSS
- Type-safe routing with Hummingbird

## Requirements

- Swift 5.10+
- macOS 14+

## Running the Application

```bash
# Build the application
swift build

# Run the application
swift run App

# The server will start on http://localhost:8080/
```

## Development

```bash
# Run tests
swift test

# Build for release
swift build -c release

# Format code
swift-format format --in-place --recursive Sources/ Tests/
```

## Project Structure

```text
Sources/
  App/
    App.swift                    - Main application entry point
    Pages.swift                  - HTML page templates using Elementary
    Elementary+Hummingbird.swift - Integration between Elementary and Hummingbird

Public/
  images/
    logo.svg                     - NLF logo

Tests/
  AppTests/
    AppTests.swift               - Application tests
```

## About Neon Law Foundation

Neon Law Foundation is a non-profit organization founded in 2021, dedicated to
increasing access to justice with open source software.

### Our Focus

- **Swift Programming** - Our open source software is primarily written in Swift
- **Sagebrush Standards** - Standardized legal documentation, processes, and
  computable contracts
- **Access to Justice** - Making legal services more accessible through
  technology

We make it easier for AI to ground itself on legal templates and workflows.

## License

This project is licensed under the **GNU Affero General Public License v3.0
(AGPL-3.0)**.

See the [LICENSE](LICENSE) file for full details.

© 2025 Neon Law Foundation.
