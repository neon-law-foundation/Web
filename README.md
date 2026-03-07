# NLF Web

A modern web application for Neon Law Foundation built with Hummingbird and
Elementary.

## Overview

This is a Swift-based web application that serves the Neon Law Foundation
website. It uses:

- **Hummingbird** - Modern Swift web framework
- **HummingbirdLambda** - AWS Lambda adapter (API Gateway v2)
- **Elementary** - Type-safe HTML rendering in Swift
- **Tailwind CSS** - Utility-first CSS framework (via CDN in local/staging)

## Deployment

This app is deployed as an **AWS Lambda function** behind API Gateway v2.

- **Runtime**: `provided.al2023` (Lambda custom runtime)
- **Architecture**: `arm64` (Graviton)
- **Handler**: `bootstrap`

CodeBuild compiles the Swift binary targeting Linux ARM64, renames it
`bootstrap`, zips it, and calls `aws lambda update-function-code`. The
`--static-swift-stdlib` flag embeds the Swift standard library into the binary
so no Swift runtime is needed in the Lambda environment.

The `ENV` environment variable controls the mode:

- `production` / `staging` — runs as `APIGatewayV2LambdaFunction`
- anything else (default: `local`) — runs as a local Hummingbird server on
  port 8000

Infrastructure (Lambda function, API Gateway, CodeBuild project, IAM roles)
is managed in `Sagebrush/AWS`. See that repo's README for the pending setup
plan.

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

- Swift 6.0+
- macOS 15+

## Running the Application

```bash
# Build the application
swift build

# Run the application
swift run App

# The server will start on http://localhost:8000/
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

© 2026 Neon Law Foundation.
