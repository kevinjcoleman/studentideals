var SearchItem = React.createClass({

  render: function() {
    return (
      <li role="option" 
          className="search-item" 
          key={this.props.key}>{this.props.content}</li>
      );
  }
});
