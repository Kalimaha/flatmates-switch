import React, { PureComponent } from "react";
import PropTypes from "prop-types";
import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import { withStyles } from "@material-ui/core/styles";

import Button from "@material-ui/core/Button";
import DialogTitle from "@material-ui/core/DialogTitle";
import Dialog from "@material-ui/core/Dialog";
import DialogActions from "@material-ui/core/DialogActions";
import DialogContent from "@material-ui/core/DialogContent";
import FormControl from "@material-ui/core/FormControl";
import FormHelperText from "@material-ui/core/FormHelperText";
import Input from "@material-ui/core/Input";
import InputLabel from "@material-ui/core/InputLabel";
import Slide from "@material-ui/core/Slide";

const styles = theme => ({
  root: {
    width: "100%",
    maxWidth: 480,
    backgroundColor: theme.palette.background.paper,
  },
  buttonStyle: {
    float: "right",
  },
  listItemStyle: {
    marginBottom: theme.spacing.unit,
    borderBottom: "1px solid #cfcfcf",
  },
  formControl: {
    margin: theme.spacing.unit,
  },
  paperStyle: {
    ...theme.mixins.gutters(),
    paddingTop: theme.spacing.unit * 2,
    paddingBottom: theme.spacing.unit * 2,
  },
});

function Transition(props) {
  return <Slide direction="up" {...props} />;
}

class FormContainer extends PureComponent {
  state = {
    externalId: "",
  };

  handleClose = () => {
    this.props.onClose(this.props.selectedValue);
  };

  handleChange = event => {
    this.setState({ name: event.target.value });
  };

  renderAddForm = () => {
    const { classes, ...other } = this.props;
    return (
      <Dialog
        TransitionComponent={Transition}
        onClose={this.handleClose}
        aria-labelledby="simple-dialog-title"
        {...other}
      >
        <DialogTitle id="simple-dialog-title">Add Toggle</DialogTitle>
        <DialogContent>
          <FormControl className={classes.formControl}>
            <InputLabel htmlFor="input-external-id">External ID</InputLabel>
            <Input id="input-external-id" value={this.state.id} onChange={this.handleChange} />
            <FormHelperText id="input-external-helper-text">External ID to be sent</FormHelperText>
          </FormControl>
          <FormControl className={classes.formControl}>
            <InputLabel htmlFor="input-env">Environment</InputLabel>
            <Input id="input-env" value={this.state.env} onChange={this.handleChange} />
            <FormHelperText id="input-env-helper-text">Test, Staging, Prod</FormHelperText>
          </FormControl>
          <FormControl className={classes.formControl}>
            <InputLabel htmlFor="input-active">Active</InputLabel>
            <Input id="input-active" value={this.state.active} onChange={this.handleChange} />
          </FormControl>
          <FormControl className={classes.formControl}>
            <InputLabel htmlFor="input-type">Type</InputLabel>
            <Input id="input-type" value={this.state.type} onChange={this.handleChange} />
            <FormHelperText id="input-type-helper-text">
              "simple", "attributes_based", "godsend", "attributes_based_godsend"
            </FormHelperText>
          </FormControl>
        </DialogContent>

        <DialogActions>
          <Button onClick={this.saveToggle} color="primary">
            Add new
          </Button>
        </DialogActions>
      </Dialog>
    );
  };

  render() {
    const { classes, onClose, selectedValue, ...other } = this.props;

    return this.renderAddForm();
  }
}

function mapStateToProps(state) {
  // whatever is returned will show up as props
  return {
    state,
  };
}

// Anything returned from this function will end up as props
function mapDispatchToProps(dispatch) {
  // Whenever dispatch is called the result should be passed
  // to all of the reducers
  return bindActionCreators({}, dispatch);
}

const StyledFormContainer = withStyles(styles)(FormContainer);
// To promote a component to a container (smart component) - it needs
// to know about this new dispatch method. Make it available
// as a prop.
export default connect(mapStateToProps, mapDispatchToProps)(StyledFormContainer);
