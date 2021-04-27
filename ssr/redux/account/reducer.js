import produce from "immer"

const initState = {
  account: null
}

const accountReducer = produce((draft, action) => {
  switch (action.type) {
    case "ACCOUNT::SET_ACCOUNT": {
      draft.account = action.payload
      break
    }
    default: {
      break;
    }
  }
}, initState)

export default accountReducer