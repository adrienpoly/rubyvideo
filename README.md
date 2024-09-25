# Rubyvideo.dev

[Rubyvideo.dev](https://www.rubyvideo.dev), inspired by [pyvideo.org](https://pyvideo.org/), is designed to index all Ruby-related videos from conferences and meetups worldwide. At the time of writing, the project has about 2400 videos indexed from 100+ conferences and 1700 speakers.

Technically the project is built using the lastest Ruby and Rails goodies such as Hotwire, SolidQueue, SolidCache. For the front end part we use Vite, Tailwind with Daisyui components and Stimulus.

It is deployed on an [Hetzner VPS]() with Kamal with SQlite as the main database.

For compatible browsers it tries to demonstrate some of teh possibilities of Page View Transition API.

## Contributing

This project is open source, and contributions are greatly appreciated. One of the most direct ways to contribute at this time is by adding more content. For more information on contributing, please visit [this page](/docs/contributing.md).

## Getting Started

We have tried to make the setup process as simple as possible so that in a few commands you can have the project with real data running locally.

### Requirements

- Ruby 3.3.5
- Docker and docker-compose (for Meilisearch)
- Node.js 20.11.0
- Meilisearch 1.1

### Setup

To prepare your database and seed content, run:

```
bin/setup
```

### Environment Variables

You can use the `.env.sample` file as a guide for the environment variables required for the project. However, there are currently no environment variables necessary for simple app exploration.

### Meilisearch

[Rubyvideo.dev](https://www.rubyvideo.dev) search uses Meilisearch as a search engine.

To start the app, you need to have a Meilisearch service started. There is a Docker Compose available

In a new terminal :

```
docker-compose up
```

Troubleshooting:

- if no search results are returned, most probably the index is empty. You can reindex by running `Talk.reindex!` in the Rails console.
- if they are no talks at all you need to run rails db:seed first

### Starting the Application

The following command will start Rails, SolidQueue and Vite (for CSS and JS).

```
bin/dev
```

## Linter

The CI performs 3 checks:

- erblint
- standardrb
- standard (js)

Before committing your code you can run `bin/lint` to detect and potentially autocorrect lint errors.

To follow Tailwind CSS's recommended order of classes, you can use [Prettier](https://prettier.io/) along with the [prettier-plugin-tailwindcss](https://github.com/tailwindlabs/prettier-plugin-tailwindcss), both of which are included as devDependencies. This formating is not yet enforced by the CI.

## Code of Conduct

Please note that this project is released with a Contributor Code of Conduct. By participating in this project, you agree to abide by its terms. More details can be found in the [Code of Conduct](/CODE_OF_CONDUCT.md) document.

## Credits

Thank you [Appsignal](https://appsignal.com/r/eeab047472) for providing the APM tool that helps us monitor the application.

## License

Rubyvideo.dev is open source and available under the MIT License. For more information, please see the [License](/LICENSE.md) file.
