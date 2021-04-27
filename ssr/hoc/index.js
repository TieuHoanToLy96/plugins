import { connect } from "react-redux"

const HocLayout = (ChildComponent, Layout) => {
  function Hoc(props) {
    return (
      <Layout {...props}>
        <ChildComponent {...props} />
      </Layout>
    )
  }

  const mapStateToProps = (state) => {
    return { account: state.account }
  }

  Hoc.getInitialProps = async function (ctx) {
    console.log(ctx, "ctx")
    let user = {
      claims: { ...ctx.req.claims, access_token: ctx.req.cookies.jwt },
    }

    console.log(user, "ctx.store")

    // ctx.store.dispatch({ type: "ACCOUNT::SET_ACCOUNT", payload: user })
    return {}
  }

  return (Hoc)
}

export default HocLayout