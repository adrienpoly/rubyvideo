# Contributing Data

This guide provides steps on how to contribute new videos to the platform. If you wish to make a contribution, please submit a Pull Request (PR) with the necessary information detailed below.

### Organization

Firstly, the organization associated with the videos needs to be added to [organisations.yml](/data/organisations.yml). Here is a typical example using Railsconf as a reference:

```yml
- name: Railsconf
  website: https://railsconf.org/
  twitter: railsconf
  youtube_channel_name: confreaks
  youtube_channel_id: UCWnPjmqvljcafA0z2U1fwKQ # This is optional
  kind: conference # Choose either 'conference' or 'meetup'
  frequency: yearly # Specify if it's 'yearly' or 'monthly'
  language: english # Default language of the talks from this conference
```

If there are any issues or uncertainties, feel free to raise them during the PR process. We appreciate your contribution and look forward to expanding the video content.
