import { BrowserRouter as Router, Switch, Route, Link } from 'react-router-dom';
import useEth from '../../contexts/EthContext/useEth';

function Header() {

  return (
    <div className='bg-gradient-to-b from-gray-700 to-gray-900'>
      <nav className="navbar navbar-expand-lg navbar-light bg-light">
      <ul className="navbar-nav mr-auto">
        <li><Link to={'/'} className="nav-link"> Lawfirm Registration </Link></li>
        <li><Link to={'/user'} className="nav-link">User</Link></li>
      </ul>
      </nav>
    </div>
  );
}

export default Header;