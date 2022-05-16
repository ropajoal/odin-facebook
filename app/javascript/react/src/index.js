import { define } from 'remount'      
//import Hello from "./components/Hello"
import App from './components/App'
//import Clock from './components/clock';
                                      
define({ 'main-component': App })
// Use it if you don't plan to use "remount"                

/*
const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <!--<App />-->
		<h1>Hello Everybody</h1>
  </React.StrictMode>
);
*/
