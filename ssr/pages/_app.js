import App from "next/app"
import Head from "next/head"
import { Provider } from "react-redux"

import "../styles/main.sass"
import "../styles/index.css"

import { connectRedux } from "/redux/store"

class MyApp extends App {
  static async getInitialProps({ Component, ctx }) {
    return {
      pageProps: Component.getInitialProps
        ? await Component.getInitialProps(ctx)
        : {}
    }
  }

  render() {
    const { Component, pageProps, store } = this.props
    return (
      <div>
        <Head>
          <link href="/static/iconfont/iconfont.woff2" rel="stylesheet" />
          <link href="/static/iconfont/iconfont.woff" rel="stylesheet" />
          <link href="/static/iconfont/iconfont.ttf" rel="stylesheet" />
          <link href="/static/iconfont/iconfont.css" rel="stylesheet" />
          <script src="/static/iconfont/iconfont.js"></script>
        </Head>
        <Component {...pageProps} />
      </div>
    )
  }
}

export default MyApp