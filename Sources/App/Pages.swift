import Elementary

extension MainLayout: Sendable where Body: Sendable {}

struct MainLayout<Body: HTML>: HTMLDocument {
    var title: String
    @HTMLBuilder var pageContent: Body

    var head: some HTML {
        meta(.charset(.utf8))
        meta(.name(.viewport), .content("width=device-width, initial-scale=1.0"))
        meta(
            .name("description"),
            .content(
                "Non-profit organization founded in 2021 increasing access to justice with open source software. Making it easier for AI to ground itself on legal templates and workflows."
            )
        )
        meta(
            .name("keywords"),
            .content(
                "access to justice, open source software, legal technology, Swift programming, Sagebrush Standards, legal templates, legal workflows"
            )
        )
        meta(.name("author"), .content("Neon Law Foundation"))
        meta(.property("og:title"), .content("Neon Law Foundation | Access to Justice through Open Source"))
        meta(
            .property("og:description"),
            .content("Non-profit organization increasing access to justice with open source software. Founded 2021.")
        )
        meta(.property("og:type"), .content("website"))
        meta(.property("og:url"), .content("https://www.neonlaw.org"))

        HTMLComment("Using Tailwind CSS via CDN - replace with built version for production")
        script(.src("https://cdn.tailwindcss.com")) {}

        style {
            HTMLRaw(
                """
                @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap');
                body {
                    font-family: 'Inter', system-ui, -apple-system, sans-serif;
                }
                """
            )
        }
    }

    var body: some HTML {
        Elementary.body(.class("bg-gray-50")) {
            pageContent
        }
    }
}

struct HomePage: HTML {
    var content: some HTML {
        header(.class("bg-white shadow-sm")) {
            div(.class("container mx-auto px-6 py-6")) {
                div(.class("flex items-center gap-4")) {
                    img(.src("/images/logo.svg"), .alt("Neon Law Foundation Logo"), .class("h-16 w-16"))
                    div {
                        h1(.class("text-3xl font-bold text-gray-900")) {
                            span(.class("text-cyan-600")) { "Neon Law" }
                            " "
                            span(.class("text-gray-700")) { "Foundation" }
                        }
                        p(.class("text-sm text-gray-600")) { "Increasing Access to Justice" }
                    }
                }
            }
        }

        main {
            // Hero Section
            section(.class("bg-gradient-to-br from-cyan-50 to-blue-50 py-20")) {
                div(.class("container mx-auto px-6")) {
                    div(.class("max-w-4xl mx-auto text-center")) {
                        h2(.class("text-5xl font-bold text-gray-900 mb-6")) {
                            "Increasing Access to Justice with Open Source Software"
                        }
                        h3(.class("text-2xl font-semibold text-gray-700 mb-8")) {
                            "Making Legal Services More Accessible Through Technology"
                        }

                        p(.class("text-xl text-gray-700 mb-8 leading-relaxed")) {
                            "At Neon Law Foundation, we develop open source software primarily written in Swift to improve access to justice. Our Sagebrush Standards make it easier for AI to ground itself on legal templates and workflows."
                        }

                        div(.class("flex justify-center gap-4")) {
                            a(
                                .href("mailto:support@neonlaw.org"),
                                .class(
                                    "inline-block bg-cyan-600 text-white font-bold px-8 py-4 rounded-lg hover:bg-cyan-700 transition-colors shadow-lg"
                                )
                            ) {
                                "Contact Us"
                            }
                        }
                    }
                }
            }

            // Who We Are Section
            section(.class("py-20")) {
                div(.class("container mx-auto px-6")) {
                    div(.class("max-w-4xl mx-auto")) {
                        h2(.class("text-4xl font-bold text-gray-900 mb-8 text-center")) { "Who We Are" }

                        p(.class("text-lg text-gray-700 mb-6 leading-relaxed")) {
                            "We are a non-profit organization dedicated to increasing access to justice through open source software. Our team develops innovative legal technology solutions using Swift programming language. We provide tools, standards, and resources that make legal services more accessible and help AI systems better understand legal processes."
                        }

                        p(.class("text-xl text-cyan-700 font-semibold text-center mt-8")) {
                            "Join us in our mission to democratize access to justice through technology."
                        }
                    }
                }
            }

            // Technology Stack Section
            section(.class("bg-gray-100 py-20")) {
                div(.class("container mx-auto px-6")) {
                    h2(.class("text-4xl font-bold text-gray-900 mb-12 text-center")) { "Our Technology Stack" }

                    div(.class("grid md:grid-cols-3 gap-8 max-w-6xl mx-auto")) {
                        // Swift Programming
                        article(.class("bg-white rounded-2xl shadow-lg p-8")) {
                            div(.class("text-6xl mb-4 text-center")) { "🚀" }
                            h3(.class("text-2xl font-bold text-gray-900 mb-4 text-center")) { "Swift Programming" }
                            p(.class("text-gray-700 mb-6 leading-relaxed")) {
                                "Our open source software is primarily written in Swift, a powerful and intuitive programming language that enables us to build robust legal technology solutions for both server and client applications."
                            }
                            div(.class("text-center")) {
                                a(
                                    .href("mailto:support@neonlaw.org"),
                                    .class("text-cyan-600 hover:text-cyan-700 font-semibold")
                                ) {
                                    "Contact Us →"
                                }
                            }
                        }

                        // Sagebrush Standards
                        article(.class("bg-white rounded-2xl shadow-lg p-8")) {
                            div(.class("text-6xl mb-4 text-center")) { "📋" }
                            h3(.class("text-2xl font-bold text-gray-900 mb-4 text-center")) { "Sagebrush Standards" }
                            p(.class("text-gray-700 mb-6 leading-relaxed")) {
                                "Our standardized approach to legal documentation, processes, and computable contracts ensures consistency and reliability. Sagebrush Standards streamline legal workflows, make them more accessible, and help AI systems better understand legal documents."
                            }
                            div(.class("text-center")) {
                                a(
                                    .href("mailto:support@neonlaw.org"),
                                    .class("text-cyan-600 hover:text-cyan-700 font-semibold")
                                ) {
                                    "Contact Us →"
                                }
                            }
                        }

                        // Access to Justice
                        article(.class("bg-white rounded-2xl shadow-lg p-8")) {
                            div(.class("text-6xl mb-4 text-center")) { "⚖️" }
                            h3(.class("text-2xl font-bold text-gray-900 mb-4 text-center")) { "Access to Justice" }
                            p(.class("text-gray-700 mb-6 leading-relaxed")) {
                                "We're committed to making legal services more accessible through technology. Our open source tools help reduce barriers and make it easier for everyone to navigate the legal system."
                            }
                            div(.class("text-center")) {
                                a(
                                    .href("mailto:support@neonlaw.org"),
                                    .class("text-cyan-600 hover:text-cyan-700 font-semibold")
                                ) {
                                    "Contact Us →"
                                }
                            }
                        }
                    }
                }
            }

            // Quote Section
            section(.class("py-20 bg-gradient-to-r from-cyan-600 to-blue-600")) {
                div(.class("container mx-auto px-6")) {
                    blockquote(.class("max-w-4xl mx-auto text-center")) {
                        p(.class("text-2xl md:text-3xl text-white italic mb-6 leading-relaxed")) {
                            "\"Equal justice under law is not merely a caption on the facade of the Supreme Court building, it is perhaps the most inspiring ideal of our society\""
                        }
                        cite(.class("text-cyan-100 text-lg font-semibold")) {
                            "— Supreme Court Justice Lewis F. Powell Jr."
                        }
                    }
                }
            }

            // Call to Action
            section(.class("py-20")) {
                div(.class("container mx-auto px-6 text-center")) {
                    div(.class("max-w-3xl mx-auto")) {
                        h2(.class("text-4xl font-bold text-gray-900 mb-6")) { "Get Involved" }
                        p(.class("text-xl text-gray-700 mb-8")) {
                            "Help us increase access to justice through open source software. Join our mission to make legal services more accessible for everyone."
                        }
                        a(
                            .href("mailto:support@neonlaw.org"),
                            .class(
                                "inline-block bg-cyan-600 text-white font-bold px-8 py-4 rounded-lg hover:bg-cyan-700 transition-colors shadow-lg"
                            )
                        ) {
                            "Contact Us"
                        }
                    }
                }
            }
        }

        footer(.class("bg-gray-900 text-gray-300 py-12")) {
            div(.class("container mx-auto px-6")) {
                div(.class("grid md:grid-cols-2 gap-8 mb-8")) {
                    div {
                        h3(.class("text-xl font-bold text-white mb-4")) { "Neon Law Foundation" }
                        p(.class("mb-4 leading-relaxed")) {
                            "Founded in 2021, we increase access to justice with open source software primarily written in Swift programming language."
                        }
                        p {
                            span(.class("font-semibold")) { "Contact: " }
                            a(.href("mailto:support@neonlaw.org"), .class("text-cyan-400 hover:text-cyan-300")) {
                                "support@neonlaw.org"
                            }
                        }
                    }

                    div {
                        h4(.class("text-lg font-bold text-white mb-4")) { "Follow Us" }
                        a(
                            .href("https://linkedin.com/company/neon-law-foundation/"),
                            .class("text-cyan-400 hover:text-cyan-300")
                        ) {
                            "LinkedIn"
                        }
                    }
                }

                div(.class("border-t border-gray-700 pt-8 text-center")) {
                    p(.class("mb-2")) { "© 2025 by Neon Law Foundation. All rights reserved." }
                    p(.class("text-sm")) {
                        "Non-profit organization dedicated to increasing access to justice with open source software."
                    }
                }
            }
        }
    }
}
