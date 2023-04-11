import { useState, useEffect, useReducer } from 'react';
import { BrowserRouter as Router, Switch, Route, Link } from 'react-router-dom';
import useEth from '../../contexts/EthContext/useEth';

function Navbar() {
  const {
    state: { accounts }
  } = useEth();

  return (
    <nav className="navbar navbar-expand-lg navbar-light bg-light">
    <ul className="navbar-nav mr-auto">
      <li><Link to={'/'} className="nav-link"> Lawfirm Registration </Link></li>
      <li><Link to={'/user'} className="nav-link">User</Link></li>
    </ul>
    </nav>
  );
}

export default Navbar;