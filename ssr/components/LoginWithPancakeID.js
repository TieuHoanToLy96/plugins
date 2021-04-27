import { Button } from "antd"
import { useEffect, useState } from "react"
import getConfig from "next/config"

const publicRuntimeConfig = getConfig().publicRuntimeConfig

const LoginWithPancakeID = props => {
  useEffect(() => {
    setTimeout(() => {
      if (window.PancakeIDSdk)
        window.PancakeIDSdk.init(publicRuntimeConfig.PANCAKEID_CLIENT_ID, "avatar,email");
    })
  }, [])

  const handleClick = () => {
    let url = `${publicRuntimeConfig.AUTH_URL}/oauth2/authorize?grant_type=code&client_id=${
      publicRuntimeConfig.PANCAKEID_CLIENT_ID
      }&redirect_uri=${encodeURIComponent(publicRuntimeConfig.SSR_URL) + "/callback"}&scope=avatar,email,subscriptions&locale=${props.locale}`;
    window.location.href = url
  }

  return <div>
    <Button type="primary" className={`login ${props.className}`} onClick={handleClick}>Login</Button>
  </div>
}

export default LoginWithPancakeID