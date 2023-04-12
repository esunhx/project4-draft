const ErrorModal = (props) => {
    const onClickHandler = () => {
      props.onClick();
    };
  
    return (
      <div className="wd-full justify-center">
          <div className="justify-center">
          <div
            onClick={onClickHandler}>
            <div>{props.message}</div>
          </div>
        </div>
      </div>
    );
  };
  
  export default ErrorModal;