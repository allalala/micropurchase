[![Code Climate](https://codeclimate.com/github/18F/micropurchase/badges/gpa.svg)](https://codeclimate.com/github/18F/micropurchase) [![Test Coverage](https://codeclimate.com/github/18F/micropurchase/badges/coverage.svg)](https://codeclimate.com/github/18F/micropurchase/coverage)

# Micropurchase

This is a web application used to manage the bidding process for 18F's [micro-purchase threshold experiment](https://18f.gsa.gov/2015/10/13/open-source-micropurchasing/). The platform will allow vendors to bid on open opportunities with 18F, track their bids, and learn of the winning bidder. So long as vendors are registered on [SAM.gov](https://www.sam.gov) and have GitHub accounts, they will be able to view open opportunities and bid on them.

With this application, a vendor will be able to view the full list of open micro-purchasing opportunities, access bid histories, and place bids on services requested by 18F. All bids will start under $3,500 and each project will specify the desired product and method of delivery. 

This is a Ruby/Rails application using ActiveRecord and PostgreSQL. This repo contains the front end of a web app that integrates GitHub and SAM.gov. For more information on setting up the back end of the web app, see below. 


## Local Development
The application is running Ruby 2.2.3 and Rails 4.2.4. Libraries are all
available via gems.

* `bundle` to get your gem dependencies installed
* Talk to someone of the team to get the authentication secret and key
  for the github account we are using for authentication. You will want
to put these variables in your environment: `export
GITHUB_KEY=the-magic-key-given-you` and `export
GITHUB_SECRET=another-magic-key`.
* create your test and development databases: `bundle exec rake
  db:create:all db:migrate db:test:prepare`
* start the local server with `bundle exec rails s`


### Testing

```
bundle exec rspec
```
or
```
rake spec
```

## Deployment

This application is deployed on the cloud.gov PaaS which runs on Cloud Foundry. The following instructions are 18F-specific, but could easily be adapted for other Cloud Foundry instances or other web hosts.

Create the app (it's ok if the deploy fails):

```
$ cf push
```

Create the database service:

```
$ cf create-service rds shared-psql micropurchase
```

Set environment variables with `cf set-env`:

```
$ cf set-env micropurchase MPT_3500_GITHUB_KEY [the key]
$ cf set-env micropurchase MPT_3500_GITHUB_SECRET [the secret]
```

Set up the database:

```
$ cf-ssh
$~ bundle exec rake db:migrate
$~ bundle exec rake db:seed
```

Restage the app:

```
cf restage micropurchase
```

### Manual Deployment

```
cf push
```

### Automated Deployment

Pull requests merged into the `master` branch will be automatically deployed to https://micropurchase.18f.gov.

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
