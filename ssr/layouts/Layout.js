import Head from "next/head"
import Header from "/components/Header"

const Layout = props => {
  return (
    <div>
      <Header/>
      <div className="">
        <div>
          sidebar
        </div>
        <div>
          {props.children}
        </div>
      </div>
    </div>
  )
}

export default Layout