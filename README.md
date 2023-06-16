# Rubyvideo.dev

Inspired by [pyvideo.org](https://pyvideo.org/), [Rubyvideo.dev](https://rubyvideo.dev/) aims to index all Ruby-related videos from conferences and meetups around the world. Currently, the site is in its Alpha release phase with only a small proportion of available videos indexed.

## Contributing

This project is open source, and contributions are warmly welcomed. One of the most straightforward ways to contribute at this time is by adding more content. For more information on contributing, please visit [this page](/docs/contributing.md).

## Getting Started

### Environment Variables

You can use the `.env.sample` file as an example of the environment variables required for the project. However, no environment variable is currently needed for simple app exploration.

### Setup

To prepare your database and seed content, run:

```
bin/rails setup
```

### Starting the Application

The following command will start Rails, Vite (for CSS and JS), and potentially meilisearch in the future:

```
bin/dev
```

## Experimental Page Transition API



https://github.com/adrienpoly/rubyvideo/assets/7847244/768ebc63-ca23-43ea-8058-ca6ffbf295d5



Rubyvideo.dev offers experimental support for the Page View Transition API, recently released by Chrome.

Enabling page transitions with Turbo started with the addition of the following code

```js
addEventListener("turbo:before-render", (event) => {
  if (document.startViewTransition) {
    event.preventDefault();

    document.startViewTransition(() => {
      event.detail.resume();
    });
  }
});
```

The rest of the implementation was guided by examples you may find here: https://glitch.com/edit/#!/simple-set-demos?path=1-cross-fade%2Fscript.js%3A1%3A0

Currently, the implementation requires two Stimulus controllers. One controller adds a page transition class to an element on a click (before the navigation), and the other cleans the DOM from any remaining `view-transition-name` on the page. It's crucial to ensure there is only one `view-transition-name= the name` per page. Plans are in place to improve this system and potentially remove the latter controller. Still very much experimental.

## Code of Conduct

Please note that this project is released with a Contributor Code of Conduct. By participating in this project, you agree to abide by its terms. More details can be found in the [Code of Conduct](/CODE_OF_CONDUCT.md) document.

## License

Rubyvideo.dev is open source and available under the MIT License. For more information, please see the [License](/LICENSE.md) file.
