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
import { getRequestToggles, deleteRequestToggle, patchRequestToggle } from "./actions";
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
    checked: ["status"],
  };

  componentDidMount = () => {
    const { dataFetched } = this.props;
    console.log(dataFetched);
    if (!dataFetched) {
      this.props.getRequestToggles();
    }
  };

  handleToggle = value => () => {
    const { checked } = this.state;
    const currentIndex = checked.indexOf(value);
    const newChecked = [...checked];

    if (currentIndex === -1) {
      this.props.patchRequestToggle(value, true)
      newChecked.push(value);
    } else {
      this.props.patchRequestToggle(value, false)
      newChecked.splice(currentIndex, 1);
    }

    this.setState({
      checked: newChecked,
    });
  };

  deleteToggle = (id, externalId) => {
    this.props.deleteRequestToggle(id, externalId);
  };

  handleClickOpen = () => {
    this.setState({
      open: true,
    });
  };

  handleClose = value => {
    this.setState({ selectedValue: value, open: false });
  };

  renderToggles = () => {
    const { classes, featureToggles } = this.props;
    return featureToggles.map(item => (
      <ListItem className={classes.listItemStyle}>
        <ListItemText primary={`${item.label} (${item.env})`} />
        <ListItemSecondaryAction>
          <Switch
            onChange={this.handleToggle(item.id)}
            checked={this.state.checked.indexOf(item.id) !== -1}
          />
          <IconButton
            className={classes.button}
            onClick={() => this.deleteToggle(item.id, item.external_id)}
            aria-label="Delete"
            color="primary"
          >
            <DeleteIcon />
          </IconButton>
        </ListItemSecondaryAction>
      </ListItem>
    ));
  };

  render() {
    const { classes } = this.props;
    const toggleList = this.renderToggles();
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
          {toggleList}
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
    featureToggles: state.appContainerReducer.featureToggles,
    dataFetched: state.appContainerReducer.dataFetched,
  };
}

const mapDispatchToProps = dispatch =>
  bindActionCreators(
    {
      getRequestToggles,
      deleteRequestToggle,
      patchRequestToggle,
    },
    dispatch
  );

const StyledAppContainer = withStyles(styles)(AppContainer);
// To promote a component to a container (smart component) - it needs
// to know about this new dispatch method. Make it available
// as a prop.
export default connect(mapStateToProps, mapDispatchToProps)(StyledAppContainer);
