import React from 'react';
import ReactDOM from 'react-dom';

const baseURL = process.env.ENDPOINT;

const getWeatherFromApi = async () => {
  try {
    console.log('Base URL is: ', baseURL);

    const response = await fetch(`${baseURL}/weather`);
    const data = await response.json();
    console.log('Response is: ', response);
    console.log('Data is: ', data);

    return data;
  } catch (error) {
    console.error(error);
  }

  return {};
};

class Weather extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      icon: '',
    };
  }

  async componentDidMount() {
    const weather = await getWeatherFromApi();
    this.setState({ icon: weather.icon.slice(0, -1) });
  }

  render() {
    const { icon } = this.state;

    return (
      <div className="icon">
        {icon && <img src={`/img/${icon}.svg`} alt="weather icon" />}
      </div>
    );
  }
}

ReactDOM.render(
  <Weather />,
  document.getElementById('app'),
);
