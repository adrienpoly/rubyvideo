# Contributing Data

This guide provides steps on how to contribute new videos to the platform. If you wish to make a contribution, please submit a Pull Request (PR) with the necessary information detailed below.

### Organization

Firstly, the organization associated with the videos needs to be added to [organisations.yml](/data/organisations.yml). Here is a typical example using Railsconf as a reference:

```yml
- name: Railsconf
  website: https://railsconf.org/
  twitter: railsconf
  slug: railsconf
  youtube_channel_name: confreaks
  youtube_channel_id: UCWnPjmqvljcafA0z2U1fwKQ # This is optional
  kind: conference # Choose either 'conference' or 'meetup'
  frequency: yearly # Specify if it's 'yearly' or 'monthly'
  language: english # Default language of the talks from this conference
```

### Playlist

For each organisation create a folder using the slug

```
data/
├── organisations.yml
├── railsconf
│   ├── railsconf-2021
│   │   └── videos.yml
│   ├── railsconf-2022
│   │   └── videos.yml
│   ├── playlists.yml
├── speakers.yml
```

In this folder add a `playlists.yml` file with all the playlist for this event. Typically a playlist on Youtube will group all the video from one edition.

### Videos

For each play list create a directory with the slug of the playlist and add a videos.yml file.

Inside this file you should have videos listed like that.

```yml
- title: Security is hard, but we can't go shopping
  speakers:
    - André Arko
  published_at: "2013-06-25"
  description: |-
    The last few months have been pretty brutal for anyone who depends on Ruby libraries in production. Ruby is really popular now, and that's exciting! But it also means that we are now square in the crosshairs of security researchers, whether whitehat, blackhat, or some other hat. Only the Ruby and Rails core teams have meaningful experience with vulnerabilites so far. It won't last. Vulnerabilities are everywhere, and handling security issues responsibly is critical if we want Ruby (and Rubyists) to stay in high demand.
    Using Bundler's first CVE as a case study, I'll discuss responsible disclosure, as well as repsonsible ownership of your own code. How do you know if a bug is a security issue, and how do you report it without tipping off someone malicious? As a Rubyist, you probably have at least one library of your own. How do you handle security issues, and fix them without compromising apps running on the old code? Don't let your site get hacked, or worse yet, let your project allow someone else's site to get hacked! Learn from the hard-won wisdom of the security community so that we won't repeat the mistakes of others.

    Help us caption & translate this video!

    http://amara.org/v/FGba/
  video_id: tV7IPygjseI
  video_provider: youtube
```

If there are any issues or uncertainties, feel free to raise them during the PR process. We appreciate your contribution and look forward to expanding the video content.
