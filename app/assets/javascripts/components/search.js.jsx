var Search = React.createClass({
  getInitialState: function(){
    return { searchString: '',
             results: [] };
  },

  handleChange: function(e){
    if (e.target.value) {
      this.setState({searchString:e.target.value});
      $.ajax({
        url: "/search/results"+"?query="+e.target.value,
        dataType: 'json',

        success: function(data) {
          this.setState({results: data["results"]});
        }.bind(this),

        error: function(data) {
          this.setState({results: []});
        }.bind(this)
      });
    }
    else{
      this.setState({searchString:'',
                     results: []});
    }
  },


  render: function() {
    return (
      <div className="search-box-container homepage-search">
        <div className="input-group input-group-lg">
          <span className="input-group-addon"><i className="fa fa-map-marker home-search-icon"></i></span>
          <input type="text" 
             name="region_name" 
             id="region_name" 
             className="form-control ui-autocomplete-input" 
             placeholder="Search by city/school, business, category..." 
             value={this.state.searchString} 
             onChange={this.handleChange} 
          />
          <span className="input-group-btn">
          <input type="submit" name="commit" value="Search" className="btn btn-success" />
          </span>
        </div>
        <SearchList results={this.state.results} />;
      </div>
    );
  }
});
