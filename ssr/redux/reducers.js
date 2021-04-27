import { combineReducers } from "redux"
import heatmapReducer from "/redux/heatmap/reducer"
import accountReducer from "/redux/account/reducer"

const appReducer = combineReducers({
  heatmap: heatmapReducer,
  account: accountReducer
})

const rootReducer = (state, action) => {
  if (action.type == "SIGN_OUT") {
    state = undefined
  }

  return appReducer(state, action)
}

export default rootReducer
