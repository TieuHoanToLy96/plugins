const hash = require('hash.js');
const axios = require('axios');
// const jwt_decode = require('jwt-decode');
// const JWT_KEY = process.env.JWT_KEY

const handlePancakeIDCallback = (req, res) => {
  let authorization_code = req.query.authorization_code;
  let clientID = process.env.PANCAKEID_CLIENT_ID;
  let clientSecret = process.env.PANCAKEID_CLIENT_SECRET;
  let secure = hash.sha256().update(clientID + clientSecret).digest('hex');

  axios.post(`${process.env.AUTH_URL}/api/back_channel/token`, {
    authorization_code
  }, {
      headers: {
        Authorization: `Bearer ${clientID}.${secure}`
      }
    })
    .then(response => {
      let payload = response.data.payload;
      let ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress
      let user_agent = req.headers['user-agent'];
      console.log(payload, "payload")
      axios.post(
        `${process.env.API_URL}/oauth2/pancakeid/login`,
        { access_token: payload.access_token, ip, user_agent }
      )
        .then(resLogin => {
          if (resLogin.status == 200) {
            res.cookie("jwt", resLogin.data.session.jwt, { maxAge: 60 * 60 * 24 * 365 * 1000 })
            return res.redirect('/sites/list');
          }
          return res.redirect("/")
        })
        .catch(errLogin => {
          console.log("err when login", errLogin)
          res.redirect("/")
        })
    })
    .catch(err => {
      console.log('err', err)
      res.redirect("/")
    })
}

const jwt_decode = (token) => {
  if (token) {
    const base64String = token.split(".")[1];
    const decodedValue = JSON.parse(Buffer.from(base64String,
      "base64").toString("ascii"));
    console.log(decodedValue);
    return decodedValue;
  }
  return null;
}

const checkin = (req, res, next) => {
  let jwt = req.cookies.jwt;
  let now = Date.now()
  if (!jwt) return res.redirect("/");
  let claims = null;
  try {
    claims = jwt_decode(jwt)
  } catch (_err) {
    return res.redirect("/");
  }

  if (1608323052491 > claims.iat * 1000) {
    res.clearCookie('jwt')
    return res.redirect('/')
  }

  if (claims.exp * 1000 < now) return res.redirect("/");

  req.claims = claims;

  next();
}

const checkIndex = (req, res, next) => {
  let jwt = req.cookies.jwt;
  let claims = null;
  try {
    claims = jwt_decode(jwt)
  } catch (_err) {
    console.log(_err, "_err")
  }
  if (claims && claims.exp * 1000 < Date.now()) claims = null

  if (claims) return res.redirect("/sites/list");
  return next()
}

module.exports = {
  handlePancakeIDCallback,
  checkIndex,
  checkin
}