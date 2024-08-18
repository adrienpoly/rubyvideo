topics = [
  "A/B Testing",
  "Accessibility (a11y)",
  "ActionCable",
  "ActionMailbox",
  "ActionMailer",
  "ActionPack",
  "ActionText",
  "ActionView",
  "ActiveJob",
  "ActiveModel",
  "ActiveRecord",
  "ActiveStorage",
  "ActiveSupport",
  "Algorithms",
  "Android",
  "Angular.js",
  "Arel",
  "Artificial Intelligence (AI)",
  "Assembly",
  "Authentication",
  "Authorization",
  "Automation",
  "Awards",
  "Background jobs",
  "Behavior-Driven Development (BDD)",
  "Blogging",
  "Bootstrapping",
  "Bundler",
  "Business Logic",
  "Business",
  "Caching",
  "Capybara",
  "Career Development",
  "CI/CD",
  "Client-Side Rendering",
  "Code Golfing",
  "Code Organization",
  "Code Quality",
  "Command Line Interface (CLI)",
  "Communication",
  "Communication",
  "Community",
  "Compiling",
  "Components",
  "Computer Vision",
  "Concurrency",
  "Containers",
  "Content Management System (CMS)",
  "Content Management",
  "Continuous Integration (CI)",
  "Contributing",
  "CRuby",
  "Crystal",
  "CSS",
  "Data Analysis",
  "Data Integrity",
  "Data Migrations",
  "Data Persistence",
  "Data Processing",
  "Database Sharding",
  "Databases",
  "Debugging",
  "Dependency Management",
  "Deployment",
  "Design Patterns",
  "Developer Expierience (DX)",
  "Developer Tooling",
  "Developer Tools",
  "Developer Workflows",
  "DevOps",
  "Distributed Systems",
  "Diversity & Inclusion",
  "Docker",
  "Documentation Tools",
  "Documentation",
  "Domain Driven Design",
  "Domain Specific Language (DSL)",
  "dry-rb",
  "Duck Typing",
  "E-Commerce",
  "Early-Career Devlopers",
  "Editor",
  "Elm",
  "Encoding",
  "Encryption",
  "Engineering Culture",
  "Error Handling",
  "Ethics",
  "Event Sourcing",
  "Fibers",
  "Flaky Tests",
  "Frontend",
  "Functional Programming",
  "Game Shows",
  "Games",
  "Geocoding",
  "git",
  "Go",
  "Graphics",
  "GraphQL",
  "gRPC",
  "Hacking",
  "Hanami",
  "Hotwire",
  "HTML",
  "HTTP API",
  "Hybrid Apps",
  "Indie Developer",
  "Inspiration",
  "Integrated Development Environment (IDE)",
  "Integration Test",
  "Internals",
  "Internationalization (I18n)",
  "Interview",
  "iOS",
  "Java Virtual Machine (JVM)",
  "JavaScript",
  "Job Interviewing",
  "JRuby",
  "JSON Web Tokens (JWT)",
  "Just-In-Time (JIT)",
  "Kafka",
  "Keynote",
  "Language Server Protocol (LSP)",
  "Large Language Models (LLM)",
  "Leadership",
  "Legacy Applications",
  "Licensing",
  "Lightning Talks",
  "Linters",
  "Live Coding",
  "Localization (L10N)",
  "Logging",
  "Machine Learning",
  "Majestic Monolith",
  "Markup",
  "Math",
  "Memory Managment",
  "Mental Health",
  "Mentorship",
  "MFA/2FA",
  "Microcontroller",
  "Microservices",
  "Minimum Viable Product (MVP)",
  "Minitest",
  "MJIT",
  "Mocking",
  "Model-View-Controller (MVC)",
  "Monitoring",
  "Monolith",
  "mruby",
  "Multitenancy",
  "Music",
  "MySQL",
  "Naming",
  "Native Apps",
  "Native Extensions",
  "Networking",
  "Object-Oriented Programming (OOP)",
  "Object-Relational Mapper (ORM)",
  "Observability",
  "Offline-First",
  "Open Source",
  "Organizational Skills",
  "Pair Programming",
  "Panel Discussion",
  "Parallelism",
  "Parsing",
  "Passwords",
  "People Skills",
  "Performance",
  "Personal Development",
  "Phlex",
  "Podcasts",
  "PostgreSQL",
  "Pricing",
  "Privacy",
  "Productivity",
  "Profiling",
  "Progressive Web Apps (PWA)",
  "Project Planning",
  "Quality Assurance (QA)",
  "Questions and Anwsers (Q&A)",
  "Rack",
  "Ractors",
  "Rails at Scale",
  "Rails Engine",
  "Rails Plugins",
  "Rails Upgrades",
  "Railties",
  "React.js",
  "Real-Time Applications",
  "Refactoring",
  "Regex",
  "Remote Work",
  "Reporting",
  "REST API",
  "REST",
  "Rich Text Editor",
  "RJIT",
  "Robot",
  "RPC",
  "RSpec",
  "Ruby Implementations",
  "Ruby on Rails",
  "Ruby VM",
  "Rubygems",
  "Rust",
  "Scaling",
  "Science",
  "Security Vulnerability",
  "Security",
  "Selenium",
  "Server-side Rendering",
  "Servers",
  "Service Objects",
  "Shoes.rb",
  "Sidekiq",
  "Sinatra",
  "Single Page Applications (SPA)",
  "Software Architecture",
  "Sonic Pi",
  "Sorbet",
  "SQLite",
  "Startups",
  "Static Typing",
  "Stimulus.js",
  "Structured Query Language (SQL)",
  "Success Stories",
  "Swift",
  "Syntax",
  "System Programming",
  "System Test",
  "Tailwind CSS",
  "Teaching",
  "Team Building",
  "Teams",
  "Teamwork",
  "Templating",
  "Template Engine",
  "Test Coverage",
  "Test Framework",
  "Test-Driven Development",
  "Testing",
  "Threads",
  "Timezones",
  "Tips & Tricks",
  "Trailblazer",
  "Translation",
  "Transpilation",
  "TruffleRuby",
  "Turbo Native",
  "Turbo",
  "Type Checking",
  "Types",
  "Typing",
  "UI Design",
  "Unit Test",
  "Usability",
  "User Interface (UI)",
  "Version Control",
  "ViewComponent",
  "Views",
  "Virtual Machine",
  "Vue.js",
  "Web Components",
  "Web Server",
  "Websockets",
  "why the lucky stiff",
  "Workshop",
  "Writing",
  "YARV (Yet Another Ruby VM)",
  "YJIT (Yet Another Ruby JIT)"
]

# create topics
Topic.create_from_list(topics, status: :approved)
