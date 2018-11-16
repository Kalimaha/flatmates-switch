import axios from "axios";
import { COMPONENT_TITLE } from "constants";

export const SET_DATA_FETCHED = "SET_DATA_FETCHED";
export const SET_DRAFT_ERROR = "SET_DRAFT_ERROR";
export const INITIALISE_TOGGLES = "INITIALISE_TOGGLES";

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

export const deleteRequestToggle = id => dispatch => {
  axios
    .delete(`/api/feature-toggles/${id}`)
    .then(response => {
      window.location.reload();
    })
    .catch(error => {
      dispatch(setDraftError(error));
    });
};
