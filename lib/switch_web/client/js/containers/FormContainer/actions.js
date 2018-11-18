import axios from "axios";

import { COMPONENT_TITLE } from "constants";

export const ADD_TOGGLE = "ADD_TOGGLE";
export const SET_ERROR = "SET_ERROR";

export function addToggle(toggle) {
  return {
    type: ADD_TOGGLE,
    payload: toggle,
  };
}

export function setError(error) {
  return {
    type: SET_ERROR,
    payload: error,
  };
}

export const postRequestToggles = (label, externalId, env) => dispatch => {
  const payload = {
    label: label,
    external_id: externalId,
    env: env,
    active: false,
    type: "simple",
  };
  axios
    .post(`/api/feature-toggles`, payload)
    .then(response => {
      dispatch(addToggle(response.data));
    })
    .catch(error => {
      dispatch(setError(error));
    });
};
