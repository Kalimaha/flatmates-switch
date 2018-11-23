import React, { PureComponent } from "react";
import { hot } from "react-hot-loader";
import HeaderLayout from "layouts/HeaderLayout";
import BodyLayout from "layouts/BodyLayout";
import FooterLayout from "layouts/FooterLayout";
import AppContainer from "containers/AppContainer";
import styles from "./styles.scss";

class AppLayout extends PureComponent {
  render() {
    return (
      <div className={styles.home}>
        <HeaderLayout />
        <BodyLayout>
          <AppContainer />
        </BodyLayout>
        <FooterLayout />
      </div>
    );
  }
}
export default hot(module)(AppLayout);
