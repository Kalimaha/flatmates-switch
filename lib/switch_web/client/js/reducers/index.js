import { combineReducers } from "redux";
import appContainerReducer from "../containers/AppContainer/reducer";

// a function that returns a piece of the application state
// because application can have many different pieces of state == many reducers
const rootReducer = combineReducers({
  appContainerReducer,
});

export default rootReducer;
