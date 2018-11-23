import React from "react";
import { shallow } from "enzyme";
import FormContainer from "./index";

// TODO Sample mock test for now
describe("<FormContainer />", () => {
  test("should render without throwing an error", () => {
    const FormContainerComponent = () => <FormContainer />;
    const component = shallow(<FormContainerComponent />);
    expect(component.name()).toBe("Connect(FormContainer)");
  });
});
