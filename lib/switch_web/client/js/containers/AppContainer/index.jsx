import React, { PureComponent } from "react";
import { withStyles } from "@material-ui/core/styles";
import List from "@material-ui/core/List";
import ListItem from "@material-ui/core/ListItem";
import ListItemIcon from "@material-ui/core/ListItemIcon";
import ListItemSecondaryAction from "@material-ui/core/ListItemSecondaryAction";
import ListItemText from "@material-ui/core/ListItemText";
import ListSubheader from "@material-ui/core/ListSubheader";
import Switch from "@material-ui/core/Switch";
import DeleteIcon from "@material-ui/icons/Delete";
import IconButton from "@material-ui/core/IconButton";
import Button from "@material-ui/core/Button";
import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import StyledFormContainer from "../FormContainer";

const styles = theme => ({
  root: {
    width: "100%",
    maxWidth: 360,
    backgroundColor: theme.palette.background.paper,
  },
  buttonStyle: {
    float: "right",
  },
  listItemStyle: {
    marginBottom: theme.spacing.unit,
    borderBottom: "1px solid #cfcfcf",
  },
});

class AppContainer extends PureComponent {
  state = {
    open: false,
    checked: ["listingflow"],
  };

  handleToggle = value => () => {
    const { checked } = this.state;
    const currentIndex = checked.indexOf(value);
    const newChecked = [...checked];

    if (currentIndex === -1) {
      newChecked.push(value);
    } else {
      newChecked.splice(currentIndex, 1);
    }

    this.setState({
      checked: newChecked,
    });
  };

  handleClickOpen = () => {
    this.setState({
      open: true,
    });
  };

  handleClose = value => {
    this.setState({ selectedValue: value, open: false });
  };

  render() {
    const { classes } = this.props;

    return (
      <div>
        <List
          subheader={
            <ListSubheader>
              Your feature toggles
              <Button
                onClick={this.handleClickOpen}
                variant="outlined"
                color="primary"
                className={classes.buttonStyle}
              >
                Add new
              </Button>
            </ListSubheader>
          }
        >
          <ListItem className={classes.listItemStyle}>
            <ListItemText primary="Listing Flows" />
            <ListItemSecondaryAction>
              <Switch
                onChange={this.handleToggle("listingflow")}
                checked={this.state.checked.indexOf("listingflow") !== -1}
              />
              <IconButton className={classes.button} aria-label="Delete" color="primary">
                <DeleteIcon />
              </IconButton>
            </ListItemSecondaryAction>
          </ListItem>

          <ListItem>
            <ListItemText primary="Inspections" />
            <ListItemSecondaryAction>
              <Switch
                onChange={this.handleToggle("inspections")}
                checked={this.state.checked.indexOf("inspections") !== -1}
              />
              <IconButton className={classes.button} aria-label="Delete" color="primary">
                <DeleteIcon />
              </IconButton>
            </ListItemSecondaryAction>
          </ListItem>
        </List>
        <StyledFormContainer
          selectedValue={this.state.selectedValue}
          open={this.state.open}
          onClose={this.handleClose}
        />
      </div>
    );
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

const StyledAppContainer = withStyles(styles)(AppContainer);
// To promote a component to a container (smart component) - it needs
// to know about this new dispatch method. Make it available
// as a prop.
export default connect(mapStateToProps, mapDispatchToProps)(StyledAppContainer);
