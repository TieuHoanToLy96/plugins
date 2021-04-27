const express = require('express');
const cookieParser = require('cookie-parser')
const next = require('next')
const dotenv = require('dotenv');

const dev = process.env.NODE_ENV !== 'production'
const port = parseInt(process.env.PORT, 10) || 2209
const app = next({ dev })
const handle = app.getRequestHandler()

if (process.NODE_ENV != "production") require('dotenv').config({ path: './.dev.env' });

dotenv.config({ path: "./.dev.env" });

const Auth = require('./backend/auth');

app.prepare().then(() => {
  const server = express();
  server.use(cookieParser())

  server.get("/logout", (req, res) => {
    res.clearCookie("jwt")
    res.redirect("/")
  })

  server.get("/callback", Auth.handlePancakeIDCallback)
  server.get("/sites/:site_id/:path", Auth.checkin, (req, res) => handle(req, res))

  server.get("/", Auth.checkIndex, (req, res) => handle(req, res))

  server.get('*', Auth.checkin, (req, res) => {
    return handle(req, res)
  })

  server.listen(port, (err) => {
    if (err) throw err
    console.log(`Server is running on http://localhost:${port}`)
  })
})

