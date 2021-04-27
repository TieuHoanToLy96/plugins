const withSass = require('@zeit/next-sass')
const path = require('path')
const dotenv = require('dotenv');
dotenv.config({ path: './.dev.env' });

const env = {
  'PANCAKEID_CLIENT_ID': process.env.PANCAKEID_CLIENT_ID,
  'SCHEME': process.env.SCHEME,
  'API_URL': process.env.API_URL,
  'PANCAKEID_HOST': process.env.PANCAKEID_HOST,
  'AUTH_URL': process.env.AUTH_URL,
  'SSR_URL': process.env.SSR_URL
}

const withSassReturn = withSass({
  webpack(config, _) {
    config.resolve.alias[''] = path.join(__dirname, '')
    return config
  },
  // sassLoaderOptions: {
  //   includePaths: ["static/style/main.scss"]
  // }
  publicRuntimeConfig: {
    localeSubpaths: typeof process.env.LOCALE_SUBPATHS === 'string'
      ? process.env.LOCALE_SUBPATHS
      : 'none',
    ...env
  },
  // NEVER PUT any CLIENT_SECRET or SECRET VARIABLE here because it will be exposed to the client.
  env: {},
  reactStrictMode: false
})

module.exports = withSassReturn
