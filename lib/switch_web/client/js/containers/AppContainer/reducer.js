import { SET_DATA_FETCHED, SET_DRAFT_ERROR, INITIALISE_TOGGLES } from "./actions";
import { ADD_TOGGLE } from "../FormContainer/actions";

const DEFAULT_APP_SCHEMA = {
  dataFetched: false,
  error: null,
  featureToggles: [],
};

export default function(state = DEFAULT_APP_SCHEMA, action) {
  switch (action.type) {
    case SET_DATA_FETCHED:
      return {
        ...state,
        dataFetched: action.payload,
      };
    case SET_DRAFT_ERROR:
      return {
        ...state,
        error: action.payload,
      };
    case INITIALISE_TOGGLES:
      return {
        ...state,
        featureToggles: action.payload,
      };
    case ADD_TOGGLE:
      return {
        ...state,
        featureToggles: [...action.payload],
      };
    default:
      return state;
  }
}
