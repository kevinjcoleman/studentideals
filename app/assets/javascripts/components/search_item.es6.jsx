import React from 'react';
import ReactDOM from 'react-dom';

var SearchItem = React.createClass({

  render() {
    var link
    return (
      <a href={this.props.url}>
        <li role="option" className="search-item" key={this.props.id}>
          <div className="search-item-name"><b>{this.props.content}</b></div>
          <div className="search-item-type"><i>{this.props.type}</i></div>
        </li>
      </a>
      );
  }
});

export default SearchItem
