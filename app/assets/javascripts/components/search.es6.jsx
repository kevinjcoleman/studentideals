import React, {Component} from 'react';
import ReactDOM from 'react-dom';
import Autosuggest from 'react-autosuggest';

// Logic to render suggestions.
const renderSuggestion = suggestion => (
  <div>
    <div className="search-item-name">{suggestion.label}</div>
    <div className="search-item-type">{suggestion.type}</div>
  </div>
);

// Render input components.
const renderLocationInputComponent = inputProps => (
  <div className="homepage-input-group">
    <span className="input-group-addon">
      <i className="fa fa-map-marker home-search-icon"></i>
    </span>
    <input className="form-control" {...inputProps} />
  </div>
);

const renderBizCatInputComponent = inputProps => (
  <div className="homepage-input-group">
    <span className="input-group-addon">
      <i className="fa fa-search home-search-icon"></i>
    </span>
    <input className="form-control" {...inputProps} />
  </div>
);

// Always render suggestions when input is clicked.
function shouldRenderSuggestions() {
  return true;
}


class Search extends React.Component {
  constructor(props) {
    super();
    this.onLocationUpdateInput = this.onLocationUpdateInput.bind(this);
    this.onBizCatTermUpdateInput = this.onBizCatTermUpdateInput.bind(this);
    this.performLocationSearch = this.performLocationSearch.bind(this);
    this.performBizCatSearch = this.performBizCatSearch.bind(this);
    this.onClearLocations = this.onClearLocations.bind(this);
    this.onClearBizCats = this.onClearBizCats.bind(this);
    this.getBizCatValue = this.getBizCatValue.bind(this);
    this.getLocationValue = this.getLocationValue.bind(this);
    this.redirectToController = this.redirectToController.bind(this);
    var current_location_cookie = Cookies.get('location') ? JSON.parse(Cookies.get('location')) : {label: ''};
    this.state = {
      locations : [],
      current_location_value: current_location_cookie.label,
      current_location : current_location_cookie,
      bizCats : [],
      bizCatTerm : ''
    };
  }

  //Update the current location object's label to be the new value.
  onLocationUpdateInput(event, {newValue}){
    console.log("Changed!",newValue);
    this.setState({
      current_location_value: newValue
    });
  }

  //Update the bizCatTerm to be the new value.
  onBizCatTermUpdateInput(event, {newValue}){
    console.log("Changed bizCatTerm!",newValue);
    this.setState({
      bizCatTerm: newValue
    });
  }

  //LOAD SERVER DATA

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

  //Load biz/cat data from the server.
  performBizCatSearch({value}) {
    console.log("Loading bizcats from server.", value);
    var location = this.state.current_location.id;
    var location_query = location ? `&region=${location}` : '';
    $.ajax({
      url: "/search/bizcats.json?query="+value+location_query,
      dataType: 'json',

      success: function (results) {
        this.setState({bizCats: results.bizcats});
      }.bind(this),

      error: function (xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
    console.log(this.state.bizCats)
  }

  //Clear locations when one is selected.
  onClearLocations() {
    this.setState({
      locations: []
    });
  }

  //Clear bizcats when one is selected.
  onClearBizCats() {
    this.setState({
      bizCats: []
    });
  }

  // Correctly set cookie and state.
  getLocationValue(suggestion) {
    Cookies.set('location', suggestion, { expires: 365});
    console.log("Set cookie to:", suggestion.id)
    this.setState({
      current_location: suggestion
    });
    return suggestion.label;
  };

  // Redirect to redirect controller action with params.
  getBizCatValue(suggestion) {
    let location = this.state.current_location.id;
    let locationQuery = location ? `location=${location}&` : '';
    let bizCatQuery = `bizCat=${suggestion.id}&bizCatType=${suggestion.type}`
    window.location = '/search/redirect?'+locationQuery+bizCatQuery;
    return suggestion.label;
  }

  // This occurs when the search button is clicked. I'd like to apply it to the getBizCatValue as well.
  redirectToController() {
    console.log("Search button was clicked!");
  }



  render() {
    const inputLocationProps = {
      placeholder: 'Please type a location/school',
      value: this.state.current_location_value,
      onChange: this.onLocationUpdateInput
    };

    const inputBizCatProps = {
      placeholder: 'Please type a category/business',
      value: this.state.bizCatTerm,
      onChange: this.onBizCatTermUpdateInput
    };

    return (
      <div className="row">
        <Autosuggest
          id="bizcat-search"
          className="col-md-5"
          suggestions={this.state.bizCats}
          onSuggestionsFetchRequested={this.performBizCatSearch}
          onSuggestionsClearRequested={this.onClearBizCats}
          getSuggestionValue={this.getBizCatValue}
          shouldRenderSuggestions={shouldRenderSuggestions}
          renderSuggestion={renderSuggestion}
          renderInputComponent={renderBizCatInputComponent}
          inputProps={inputBizCatProps}
        />

        <Autosuggest
          id="location-search"
          className="col-md-5"
          suggestions={this.state.locations}
          onSuggestionsFetchRequested={this.performLocationSearch}
          onSuggestionsClearRequested={this.onClearLocations}
          getSuggestionValue={this.getLocationValue}
          shouldRenderSuggestions={shouldRenderSuggestions}
          renderSuggestion={renderSuggestion}
          renderInputComponent={renderLocationInputComponent}
          inputProps={inputLocationProps}
        />

      <button className="btn btn-success search-button col-xs-12 col-md-2"
              onClick={this.redirectToController}>Search</button>
      </div>
    );
  }
}

export default Search
