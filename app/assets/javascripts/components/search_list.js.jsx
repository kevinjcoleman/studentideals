var SearchList = React.createClass({

  render: function() {
    var showResults = (result, i=1) => <SearchItem key={i += 1} content={result.label} id={result.id} type={result.searchable_type} url={result.url} />;
    console.log(this.props.results.length)
    if (this.props.results.length > 0) {
      return (
        <ul role="listbox" className="search-list">   
          {this.props.results.map(showResults)}
        </ul>
      );
    }
    else{
      return (
        <div />
      );  
    }
  }
});
