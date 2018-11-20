import axios from "axios";
import { COMPONENT_TITLE } from "constants";

export const SET_DATA_FETCHED = "SET_DATA_FETCHED";
export const SET_DRAFT_ERROR = "SET_DRAFT_ERROR";
export const INITIALISE_TOGGLES = "INITIALISE_TOGGLES";
export const REMOVE_TOGGLE = "REMOVE_TOGGLE";

const setDataFetched = status => ({
  type: SET_DATA_FETCHED,
  payload: status,
});

const setDraftError = error => ({
  type: SET_DRAFT_ERROR,
  payload: error,
});

const initialiseToggles = data => ({
  type: INITIALISE_TOGGLES,
  payload: data,
});

const removeToggle = id => ({
  type: REMOVE_TOGGLE,
  payload: id,
});

export const getRequestToggles = id => dispatch => {
  const withId = id ? `/${id}` : "";

  axios
    .get(`/api/feature-toggles${withId}`)
    .then(response => {
      dispatch(setDataFetched(true));
      dispatch(initialiseToggles(response.data));
    })
    .catch(error => {
      dispatch(setDraftError(error));
    });
};

export const deleteRequestToggle = (id, externalId) => dispatch => {
  axios
    .delete(`/api/feature-toggles/${id}`)
    .then(() => {
      dispatch(removeToggle(externalId));
    })
    .catch(error => {
      dispatch(setDraftError(error));
    });
};

export const patchRequestToggle = (id, status) => dispatch => {
  const payload = {
    active: status
  }
  axios
    .patch(`/api/feature-toggles/${id}`, payload)
    .catch(error => {
      dispatch(setDraftError(error));
    });
};
