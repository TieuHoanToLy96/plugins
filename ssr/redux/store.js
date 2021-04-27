// import { createStore, applyMiddleware, compose } from "redux"
// import thunkMiddleware from "redux-thunk"
// import withRedux from "next-redux-wrapper"

// import rootReducer from "./reducers"

// export let ghost

// export const store = (initState = {}) => {
//   let s = createStore(
//     rootReducer,
//     initState,
//     compose(
//       applyMiddleware(thunkMiddleware),
//       typeof window !== "undefined" && window.devToolsExtension
//         ? window.devToolsExtension()
//         : f => f
//     )
//   )
//   ghost = s
//   return s
// }

// export const connectRedux = (mapStateToProps, mapDispatchToProps) => {
//   return (component) => withRedux(store, mapStateToProps, mapDispatchToProps)(component)
// }


import { createStore, applyMiddleware, compose } from "redux"
import thunk from "redux-thunk"
import { createWrapper } from "next-redux-wrapper"
import rootReducer from "./reducers"

const middleware = [thunk]

const composeEnhancers =
  typeof window === 'object' &&
    window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ ?
    window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__({}) : compose;

const enhancer = composeEnhancers(applyMiddleware(...middleware));

const makeStore = () => createStore(rootReducer, enhancer)

export const connectRedux = createWrapper(makeStore)
