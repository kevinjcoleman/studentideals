import React, {Component} from 'react';
import ReactDOM from 'react-dom';
import Autosuggest from 'react-autosuggest';

function getLocationValue(suggestion) {
  Cookies.set('location', suggestion, { expires: 365});
  console.log("Set cookie to:", suggestion)
  return suggestion.label;
};

// Use your imagination to render suggestions.
const renderSuggestion = suggestion => (
  <div>
    <div className="search-item-name">
      <b>{suggestion.label}</b>
    </div>
    <div className="search-item-type">
      <i>{suggestion.type}</i>
    </div>
  </div>
);

const renderLocationInputComponent = inputProps => (
  <div className="homepage-input-group">
    <span className="input-group-addon">
      <i className="fa fa-map-marker home-search-icon"></i>
    </span>
    <input className="form-control" {...inputProps} />
  </div>
);

function shouldRenderSuggestions() {
  return true;
}

class Search extends React.Component {
  constructor(props) {
    super();
    this.onLocationUpdateInput = this.onLocationUpdateInput.bind(this);
    this.performLocationSearch = this.performLocationSearch.bind(this);
    this.onClearLocations = this.onClearLocations.bind(this);
    var current_location_cookie = Cookies.get('location') ? JSON.parse(Cookies.get('location')).label : '';
    this.state = {
      locations : [],
      locationValue : current_location_cookie,
      bizCats : [],
      bizCatTerm : ''
    };
  }

  onLocationUpdateInput(event, {newValue}){
    console.log("Changed!",newValue);
    this.setState({
      locationValue: newValue
    });
  }

  //Load location data from the server.
  performLocationSearch({value}) {
    console.log("Loading locations from server.", value);
    $.ajax({
      url: "/search/locations.json?query="+value,
      dataType: 'json',

      success: function (results) {
        this.setState({locations: results.locations});
      }.bind(this),

      error: function (xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
    console.log(this.state.locations)
  }

  onClearLocations() {
    this.setState({
      locations: []
    });
  }

  render() {
    const inputProps = {
      placeholder: 'Please type a location/school',
      value: this.state.locationValue,
      onChange: this.onLocationUpdateInput
    };

    return (
      <div className="row">
        <Autosuggest
          className="col-md-6"
          suggestions={this.state.locations}
          onSuggestionsFetchRequested={this.performLocationSearch}
          onSuggestionsClearRequested={this.onClearLocations}
          getSuggestionValue={getLocationValue}
          shouldRenderSuggestions={shouldRenderSuggestions}
          renderSuggestion={renderSuggestion}
          renderInputComponent={renderLocationInputComponent}
          inputProps={inputProps}
        />

        <Autosuggest
          className="col-md-6"
          suggestions={this.state.locations}
          onSuggestionsFetchRequested={this.performLocationSearch}
          onSuggestionsClearRequested={this.onClearLocations}
          getSuggestionValue={getLocationValue}
          shouldRenderSuggestions={shouldRenderSuggestions}
          renderSuggestion={renderSuggestion}
          renderInputComponent={renderLocationInputComponent}
          inputProps={inputProps}
        />
      </div>
    );
  }
}

export default Search
