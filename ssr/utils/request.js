import axios from "axios";
import getConfig from "next/config"
import { Cookies } from "react-cookie"
const { Cancel, CancelToken } = axios;

const cookies = new Cookies()


const publicRuntimeConfig = getConfig().publicRuntimeConfig

export const sendGet = (url, params, _token) => {
  let token;

  if (!_token) token = cookies.get("jwt")
  else token = _token;

  let cancel;
  let promise = new Promise((resolve, reject) => {
    if (token) {
      axios({
        method: "get",
        url,
        params,
        headers: {
          Authorization: `Bearer ${token}`
        },
        cancelToken: new CancelToken(function executor(c) {
          cancel = c;
        })
      })
        .then(res => {
          resolve(res);
        })
        .catch(err => {
          reject(err);
        });
    } else reject({ internal_error: "Thiếu access token!" });
  });
  promise.cancel = cancel;
  return promise;
};

export const sendPost = (url, params, data, _token) => {
  let token;

  if (!_token) token = cookies.get("jwt")
  else token = _token;

  let cancel;
  let promise = new Promise((resolve, reject) => {
    if (token)
      axios({
        method: "post",
        url,
        data: data,
        params,
        // baseURL: "localhost:8060",
        headers: {
          Authorization: `Bearer ${token}`
        },
        cancelToken: new CancelToken(function executor(c) {
          cancel = c;
        })
      })
        .then(res => {
          resolve(res);
        })
        .catch(err => {
          reject(err);
        });
    else reject({ internal_error: "Thiếu access token!" });
  });

  promise.cancel = cancel;
  return promise;
};

export const sendPut = (url, params, data, _token) => {
  let token;
  if (!_token) token = cookies.get("jwt")
  else token = _token;

  let cancel;
  let promise = new Promise((resolve, reject) => {
    if (token)
      axios({
        method: "put",
        url,
        params,
        data: data,
        headers: {
          Authorization: `Bearer ${token}`,
          "Access-Control-Allow-Origin": "*"
        },
        cancelToken: new CancelToken(function executor(c) {
          cancel = c;
        })
      })
        .then(res => {
          resolve(res);
        })
        .catch(err => {
          reject(err);
        });
    else reject({ internal_error: "Thiếu access token!" });
  });

  promise.cancel = cancel;
  return promise;
};

export const sendDelete = (url, params, _token) => {
  let token;

  if (!_token) token = cookies.get("jwt")
  else token = _token;

  let cancel;
  let promise = new Promise((resolve, reject) => {
    if (token)
      axios({
        method: "delete",
        url,
        params,
        headers: {
          Authorization: `Bearer ${token}`
        },
        cancelToken: new CancelToken(function executor(c) {
          cancel = c;
        })
      })
        .then(res => {
          resolve(res);
        })
        .catch(err => {
          reject(err);
        });
    else reject({ internal_error: "Thiếu access token!" });
  });
  promise.cancel = cancel;
  return promise;
};

function EventHash(hash) {
  this.hash = hash;
  this.lastestId = null;
  this.events = [];

  this.getHash = () => this.hash

  this.clearEvents = (otps = {}) => {
    for (let i = 0; i < this.events.length; i++) {
      if (!otps["removeAll"] && this.events[i].id == this.lastestId) continue;
      if (typeof this.events[i].cancel == "function") {
        this.events[i].cancel();
      }
    }
  }

  this.getEvents = () => this.events

  this.add = (func) => {
    func = typeof key == "function" ? key : func;
    if (typeof func != "function") return;

    let id = new Date().getTime();
    this.lastestId = id;

    for (let i = 0; i < this.events.length; i++) {
      if (this.events[i].id == this.lastestId) continue;
      if (typeof this.events[i].cancel == 'function') {
        this.events[i].cancel();
      };
    }
    this.events = []

    return new Promise((resolve, reject) => {
      try {
        let res = func();
        res.id = id
        this.events.push(res)

        if (typeof res.then == 'function') {
          res
            .then(response => {
              if (this.lastestId == id) {
                resolve(response);
              } else {
                for (let i = 0; i < this.events.length; i++) {
                  if (this.events[i].id == this.lastestId) continue;
                  if (typeof this.events[i].cancel == 'function') {
                    this.events[i].cancel()
                  };
                }
              }
            })
            .catch(err => {
              if (err instanceof Cancel) console.warn("Request is cancelled!")
              else reject(err);
            });
        }
      } catch (err) {
        resolve(err);
      }
    })
  }

  return {
    add: this.add,
    clearEvents: this.clearEvents,
    getHash: this.getHash,
    getEvents: this.getEvents
  }
}

export function imageUploadHandler(blobInfo, success, failure) {
  var xhr, formData;

  xhr = new XMLHttpRequest();
  xhr.withCredentials = false;
  xhr.open('POST', `${publicRuntimeConfig.LANDING_PAGE_BACKEND_URL}/api/v1/assets/upload`);
  xhr.setRequestHeader("Authorization", `Bearer ${cookies.get("jwt")}`);

  xhr.onload = function () {
    var json;

    if (xhr.status != 200) {
      failure('HTTP Error: ' + xhr.status);
      return;
    }

    json = JSON.parse(xhr.responseText);

    if (!json || typeof json.link != 'string') {
      failure('Invalid JSON: ' + xhr.responseText);
      return;
    }

    success(json.link);
  };

  formData = new FormData();
  formData.append('file', blobInfo.blob(), blobInfo.filename());
  xhr.send(formData);
}
