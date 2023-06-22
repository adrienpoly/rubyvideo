# Rubyvideo.dev

Rubyvideo.dev, inspired by [pyvideo.org](https://pyvideo.org/), is designed to index all Ruby-related videos from conferences and meetups worldwide. The site is currently in its Alpha release phase, and only a small portion of available videos has been indexed.

## Contributing

This project is open source, and contributions are greatly appreciated. One of the most direct ways to contribute at this time is by adding more content. For more information on contributing, please visit [this page](/docs/contributing.md).

## Getting Started

### Environment Variables

You can use the `.env.sample` file as a guide for the environment variables required for the project. However, there are currently no environment variables necessary for simple app exploration.

### Setup

To prepare your database and seed content, run:

```
bin/setup
```

### Meilisearch

Rubyvideo.dev search uses Meilisearch as a search engine.

To start the app, you need to have Meilisearch installed locally.

Most likely, when you run the seed process, Meilisearch won't start, and the index will not be created.

To create the index, start Meilisearch (bin/dev will start it), and in the console, run `Talk.reindex!`

This will create the local index and enable search.

### Starting the Application

The following command will start Rails, Vite (for CSS and JS), and Meilisearch.

```
bin/dev
```

## Experimental Page Transition API

https://github.com/adrienpoly/rubyvideo/assets/7847244/64d299bb-dd57-47ee-b6c9-e3e9b430fcfa

Rubyvideo.dev offers experimental support for the Page View Transition API, which was recently released by Chrome.

Initially, Page View Transitions were implemented using custom code. However, the support for page transitions with Turbo is now available through the library [Turn](https://github.com/domchristie/turn).

To enable page transitions with Turbo, include the following three lines of code:

```js
import Turn from "@domchristie/turn";
Turn.config.experimental.viewTransitions = true
Turn.start()
```

The rest of the implementation was guided by examples you can find here: https://glitch.com/edit/#!/simple-set-demos?path=1-cross-fade%2Fscript.js%3A1%3A0

## Linter

To follow Tailwind CSS's recommended order of classes, you can use [Prettier](https://prettier.io/) along with the [prettier-plugin-tailwindcss](https://github.com/tailwindlabs/prettier-plugin-tailwindcss), both of which are included as devDependencies.

## Code of Conduct

Please note that this project is released with a Contributor Code of Conduct. By participating in this project, you agree to abide by its terms. More details can be found in the [Code of Conduct](/CODE_OF_CONDUCT.md) document.

## License

Rubyvideo.dev is open source and available under the MIT License. For more information, please see the [License](/LICENSE.md) file.
